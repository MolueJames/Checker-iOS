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

// MARK: 以下方法中的执行顺序是同步的优先于异步执行, 当同步的全部执行完毕后, 异步的方法按照调用的顺序依次执行
public protocol MLDatabaseProtocol {
    
    static var table_name: Table { get set }
    
    static func createOperation()
}

// MARK: 该Extension中为异步方法, 只需要类型支持当前的MLDatabaseProtocol就可以使用了
extension MLDatabaseProtocol {
    
    public static func selectOperation(_ select: QueryType = table_name, complection: @escaping databaseCompletion<AnySequence<Row>?>, queue: DispatchQueue = DispatchQueue.main) {
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

// MARK: 该Extension中为同步方法, 只需要类型支持当前的MLDatabaseProtocol就可以使用了
extension MLDatabaseProtocol  {
    
    public static func selectOperation(_ select: QueryType = table_name) -> AnySequence<Row>? {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runSelectOperator(select)
        }
    }
    @discardableResult
    public static func insertOperation(_ insert: Insert) -> Bool {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runInsertOperator(insert)
        }
    }
    @discardableResult
    public static func updateOperation(_ update: Update) -> Bool {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runUpdataOperator(update)
        }
    }
    @discardableResult
    public static func deleteOperation(_ delete: Delete) -> Bool {
        return databaseQueue.sync {
            return MLDatabaseManager.shared.runDeleteOperator(delete)
        }
    }
}

// MARK: 该Extension中有返回值得为同步方法, 没有返回值得为异步方法, 使用这些方法需要同时支持MLDatabaseProtocol和Codable协议
extension MLDatabaseProtocol where Self: Codable {
    @discardableResult
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
    @discardableResult
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
    
    public static func selectObjectOperation(_ select: QueryType = table_name, complection: @escaping databaseCompletion<[Self]?>, queue: DispatchQueue = DispatchQueue.main) {
        databaseQueue.sync {
            let operation = MLDatabaseOperation.select(operation: select, complectionClosure: { (sequence) in
                do {
                    let list = try sequence.unwrap()
                    complection( try list.map({ try $0.decode() }))
                } catch {
                    complection(handleDBProtocolError(error: error))
                }
            })
            operation.excuteDatabaseOperation(queue: queue)
        }
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
    return MolueLogger.failure.allowNil(error)
}

fileprivate enum MLDatabaseOperation {
    case insert(operation: Insert, complectionClosure: databaseCompletion<Bool>?)
    case delete(operation: Delete, complectionClosure: databaseCompletion<Bool>?)
    case update(operation: Update, complectionClosure: databaseCompletion<Bool>?)
    case select(operation: QueryType, complectionClosure: databaseCompletion<AnySequence<Row>?>?)
}

extension MLDatabaseOperation {
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
        currentQueue.sync {
            do {
                let closure = try closure.unwrap()
                closure(resultValue)
            } catch {
                MolueLogger.failure.message(error)
            }
        }
    }
}
