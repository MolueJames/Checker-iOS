//
//  MolueDatabaseManager.swift
//  MolueDatabase
//
//  Created by James on 2018/4/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import SQLite
enum DatabaseError : Error {
    case databasePath
    case unconnection
}

let single = MolueDBManager()
public class MolueDBManager {
    public static var shared : MolueDBManager {
        return single
    }
   
    private (set) var connection: Connection?
    @discardableResult
    public func doConnection(_ fileName: String) -> Bool {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return handleDatabaseError(DatabaseError.databasePath)
        }
        do {
            self.connection = try Connection("\(path)/\(fileName).sqlite3")
            MolueLogger.database.message("file path: \(path)/\(fileName).sqlite3")
            return true
        } catch {
            return handleDatabaseError(error)
        }
    }

    private func handleDatabaseError(_ error: Error) -> Bool {
        MolueLogger.failure.message(error)
        return false
    }
    private func handleDatabaseError(_ error: Error) -> AnySequence<Row>? {
        MolueLogger.failure.message(error)
        return nil
    }
    
    @discardableResult
    public func runUpdataOperator(_ operation: Update) -> Bool {
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        do {
            try connection.run(operation)
        } catch {
            return handleDatabaseError(error)
        }
        return true
    }
    @discardableResult
    public func runInsertOperator(_ operation: Insert) -> Bool {
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        do {
            try connection.run(operation)
        } catch {
            return handleDatabaseError(error)
        }
        return true
    }
    @discardableResult
    public func runDeleteOperator(_ operation: Delete) -> Bool {
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        do {
            try connection.run(operation)
        } catch {
            return handleDatabaseError(error)
        }
        return true
    }
    @discardableResult
    public func runCreateOperator(_ operation: String) -> Bool {
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        do {
            try connection.run(operation)
        } catch {
            return handleDatabaseError(error)
        }
        return true
    }
    
    public func runSelectOperator(_ operation: QueryType) -> AnySequence<Row>? {
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        do {
            return try connection.prepare(operation)
        } catch {
            return handleDatabaseError(error)
        }
    }
    

}

public struct MolueDBHelper {
    public typealias transferClosure<T> = (Row) -> T?
    
    public static func transferSequence<T> (_ sequence: AnySequence<Row>?, closure: transferClosure<T>) -> [T] {
        var resultList = [T]()
        guard let sequence = sequence else {return resultList}
        for result in sequence {
            if let value = closure(result) {
                resultList.append(value)
            }
        }
        return resultList
    }
}

protocol DatabaseOperatorProtocol {
    
}
