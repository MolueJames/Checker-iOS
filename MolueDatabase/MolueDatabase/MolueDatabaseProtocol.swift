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
    public static func selectObjectOperation<Target: Codable>(_ closure: databaseClosure<QueryType>? = nil, completion: @escaping databaseCompletion<[Target]>, queue: DispatchQueue = DispatchQueue.main) {
        selectOperation(closure, complection: { (sequence) in
            guard let list = sequence else { return }
            do {
                completion( try list.map({ try $0.decode() }))
            } catch {
                MolueLogger.failure.error(error)
            }
        }, queue: queue)
    }
    
    private static func selectOperation(_ closure: databaseClosure<QueryType>? = nil, complection: @escaping databaseCompletion<AnySequence<Row>?>, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            var query: QueryType = table_name
            if let closure = closure {
                query = closure(table_name)
            }
            let operation = MLDatabaseOperation.select(operation: query, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func insertOperation<T: Codable>(_ object: T, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
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
    
    public static func insertOperation(_ closure: @escaping databaseClosure<Insert>, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let insert = closure(table_name)
            let operation = MLDatabaseOperation.insert(operation: insert, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func deleteOperation(_ closure: @escaping databaseClosure<Delete>, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let delete = closure(table_name)
            let operation = MLDatabaseOperation.delete(operation: delete, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func updateOperation(_ closure: @escaping databaseClosure<Update>, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let update = closure(table_name)
            let operation = MLDatabaseOperation.update(operation: update, complectionClosure: complection)
            operation.excuteDatabaseOperation(queue: queue)
        }
    }
    
    public static func updateObjectOperation<T: Codable>(_ object: T, complection: databaseCompletion<Bool>? = nil, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            do {
                let update = try table_name.update(object)
                let operation = MLDatabaseOperation.update(operation: update, complectionClosure: complection)
                operation.excuteDatabaseOperation(queue: queue)
            } catch {
                MolueLogger.failure.error(error)
            }
        }
    }
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
        guard let closure = closure else {return}
        currentQueue.sync { closure(resultValue) }
    }
}
