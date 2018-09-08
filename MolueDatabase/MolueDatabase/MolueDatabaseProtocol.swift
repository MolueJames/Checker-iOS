//
//  MolueDBTransfer.swift
//  MolueDatabase
//
//  Created by James on 2018/5/2.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import SQLite
import MolueUtilities

public typealias databaseClosure<T> = (Table) -> T

public typealias databaseCompletion<T> = (T) -> Void

private let databaseQueue = DispatchQueue(label: "MLDatabaseQueue")

private let completionQueue = DispatchQueue(label: "MLDBOperationQueue")

public protocol MLDatabaseProtocol {
    
    static var table_name: Table { get set }
    
    static func createOperation()
}

extension MLDatabaseProtocol {
    
    public static func selectOperation(_ select: QueryType, complection: @escaping databaseCompletion<AnySequence<Row>?>, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = MLDatabaseOperation.select(operation: select, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func insertOperation(_ insert: Insert, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = MLDatabaseOperation.insert(operation: insert, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func deleteOperation(_ delete: Delete, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = MLDatabaseOperation.delete(operation: delete, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func updateOperation(_ update: Update, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = MLDatabaseOperation.update(operation: update, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
}

extension MLDatabaseProtocol  {

    public static func selectOperation(_ select: QueryType = table_name) -> AnySequence<Row>? {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runSelectOperator(select)
        }
    }
    
    public static func insertOperation(_ insert: Insert) {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runInsertOperator(insert)
        }
    }
    
    public static func updateOperation(_ update: Update) -> Bool {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runUpdataOperator(update)
        }
    }
    
    public static func deleteOperation(_ delete: Delete) -> Bool {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runDeleteOperator(delete)
        }
    }
}

extension MLDatabaseProtocol where Self: Codable {
    
    public static func updateObjectOperation(query: QueryType, object: Self) -> Bool {
        return databaseQueue.sync {
            do {
                let update = try query.update(object)
                return MLDatabaseManager.shared.runUpdataOperator(update)
            } catch {
                return handleDBProtocolError(error);
            }
        }
    }
    
    public static func insertObjectOperation(_ object: Self) -> Bool {
        return databaseQueue.sync {
            do {
                let insert = try table_name.insert(object)
                return MLDatabaseManager.shared.runInsertOperator(insert)
            } catch {
                return handleDBProtocolError(error)
            }
        }
    }
    
    public static func selectObjectOperation(_ select: QueryType = table_name) -> [Self]? {
        return databaseQueue.sync {
            let sequence = MLDatabaseManager.shared.runSelectOperator(select);
            do {
                let list = try sequence.unwrap()
                return try list.map({ try $0.decode() })
            } catch {
                return handleDBProtocolError(error: error)
            }
        }
    }
    
    public static func selectObjectOperation(_ select: QueryType, completion: @escaping databaseCompletion<[Self]?>, queue: DispatchQueue = DispatchQueue.main) {
        selectOperation(select, complection: { (sequence) in
            do {
                let list = try sequence.unwrap()
                completion( try list.map({ try $0.decode() }))
            } catch {
                completion(handleDBProtocolError(error: error))
            }
        })
    }
    
    public static func updateObjectOperation(_ object: Self, query: QueryType, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            do {
                let update = try query.update(object)
                let operation = MLDatabaseOperation.update(operation: update, complectionClosure: complection)
                operation.excuteDatabaseOperation(queue: queue)
            } catch {
                MolueLogger.failure.error(error)
            }
        }
    }
    
    public static func insertOperation(_ object: Self, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            do {
                let insert = try table_name.insert(object)
                let operation = MLDatabaseOperation.insert(operation: insert, complectionClosure: complection)
                operation.excuteDatabaseOperation(queue: queue)
            } catch {
                MolueLogger.failure.error(error)
            }
        }
    }
}

fileprivate func handleDBProtocolError(_ error: Error) -> Bool {
    MolueLogger.failure.message(error)
    return false
}

fileprivate func handleDBProtocolError<T>(error: Error) -> T? {
    return MolueLogger.failure.returnNil(error)
}

fileprivate enum MLDatabaseOperation {
    case insert(operation: Insert, complectionClosure: databaseCompletion<Bool>?)
    case delete(operation: Delete, complectionClosure: databaseCompletion<Bool>?)
    case update(operation: Update, complectionClosure: databaseCompletion<Bool>?)
    case select(operation: QueryType, complectionClosure: databaseCompletion<AnySequence<Row>?>?)
    
    fileprivate func excuteDatabaseOperation(queue: DispatchQueue) {
        completionQueue.async {
            switch self {
            case .select (let operation, let closure):
                let sequence = MLDatabaseManager.shared.runSelectOperator(operation)
                self.completionOperation(closure, resultValue: sequence, queue: queue)
            case .insert (let operation, let closure):
                let isSuccess = MLDatabaseManager.shared.runInsertOperator(operation)
                self.completionOperation(closure, resultValue: isSuccess, queue: queue)
            case .delete (let operation, let closure):
                let isSuccess = MLDatabaseManager.shared.runDeleteOperator(operation)
                self.completionOperation(closure, resultValue: isSuccess, queue: queue)
            case .update (let operation, let closure):
                let isSuccess = MLDatabaseManager.shared.runUpdataOperator(operation)
                self.completionOperation(closure, resultValue: isSuccess, queue: queue)
            }
        }
    }
    private func completionOperation<T> (_ closure: databaseCompletion<T>?, resultValue: T, queue currentQueue: DispatchQueue) {
        do {
            let closure = try closure.unwrap()
            currentQueue.sync {
                closure(resultValue)
            }
        } catch {
            MolueLogger.failure.message(error)
        }
    }
}
