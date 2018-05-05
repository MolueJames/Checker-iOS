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

public protocol MLDatabaseProtocol {
    
    static var table_name: Table { get set }
    
    static func createOperation()
    
    static func insertOperation(_ closure: databaseClosure<Insert>) -> Bool
    
    static func insertOperation<T: Codable>(_ object: T) -> Bool
    
    static func updateObjectOperation<T: Codable>(_ object: T) -> Bool
    
    static func updateOperation(_ closure: databaseClosure<Update>) -> Bool
    
    static func deleteOperation(_ closure: databaseClosure<Delete>) -> Bool
    
    static func selectObjectOperation<Target: Codable>(_ closure: databaseClosure<QueryType>?) -> [Target]
    
    static func selectOperation(_ closure: databaseClosure<QueryType>?) -> AnySequence<Row>?
}

extension MLDatabaseProtocol {
    
    public static func selectObjectOperation<Target: Codable>(_ closure: databaseClosure<QueryType>? = nil) -> [Target] {
        var result = [Target]()
        let sequence = selectOperation(closure)
        guard let list = sequence else { return result }
        do {
            result = try list.map({ try $0.decode() })
        } catch {
            MolueLogger.failure.message(error)
        }
        return result
    }
    
    public static func selectOperation(_ closure: databaseClosure<QueryType>? = nil) -> AnySequence<Row>? {
        var query: QueryType = table_name
        if let closure = closure {
            query = closure(table_name)
        }
        return MLDatabaseManager.shared.runSelectOperator(query)
    }
    
    @discardableResult
    public static func insertOperation<T: Codable>(_ object: T) -> Bool {
        var isSuccess = false
        do {
            let insert = try table_name.insert(object)
            isSuccess = MLDatabaseManager.shared.runInsertOperator(insert)
        } catch {
            MolueLogger.failure.message(error)
        }
        return isSuccess
    }
    
    @discardableResult
    public static func insertOperation(_ closure: databaseClosure<Insert>) -> Bool {
        return MLDatabaseManager.shared.runInsertOperator(closure(table_name))
    }
    
    @discardableResult
    public static func deleteOperation(_ closure: databaseClosure<Delete>) -> Bool {
        return MLDatabaseManager.shared.runDeleteOperator(closure(table_name))
    }
    
    @discardableResult
    public static func updateOperation(_ closure: databaseClosure<Update>) -> Bool {
        return MLDatabaseManager.shared.runUpdataOperator(closure(table_name))
    }
    
    @discardableResult
    public static func updateObjectOperation<T: Codable>(_ object: T) -> Bool {
        var isSuccess = false
        do {
            let update = try table_name.update(object)
            isSuccess = MLDatabaseManager.shared.runUpdataOperator(update)
        } catch {
            MolueLogger.failure.message(error)
        }
        return isSuccess
    }
}
