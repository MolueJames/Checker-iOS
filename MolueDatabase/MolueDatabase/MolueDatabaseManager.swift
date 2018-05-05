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

let single = MLDatabaseManager()
public class MLDatabaseManager {
    public static var shared : MLDatabaseManager {
        return single
    }
   
    private (set) var connection: Connection?
    let databaseLock = NSLock()
    
    @discardableResult
    public func doConnection(_ fileName: String) -> Bool {
        databaseLock.lock()
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return handleDatabaseError(DatabaseError.databasePath)
        }
        var isSuccess = false
        do {
            connection = try Connection("\(path)/\(fileName).sqlite3")
            MolueLogger.database.message("file path: \(path)/\(fileName).sqlite3")
            isSuccess = true
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return isSuccess
    }
}

extension MLDatabaseManager {
    
    @discardableResult
    public func runUpdataOperator(_ operation: Update) -> Bool {
        databaseLock.lock()
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        var isSuccess = false
        do {
            try connection.run(operation)
            isSuccess = true
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return isSuccess
    }
    
    @discardableResult
    public func runInsertOperator(_ operation: Insert) -> Bool {
        databaseLock.lock()
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        var isSuccess = false
        do {
            try connection.run(operation)
            isSuccess = true
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return isSuccess
    }
    
    @discardableResult
    public func runDeleteOperator(_ operation: Delete) -> Bool {
        databaseLock.lock()
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        var isSuccess = false
        do {
            try connection.run(operation)
            isSuccess = true
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return isSuccess
    }
    
    @discardableResult
    public func runCreateOperator(_ operation: String) -> Bool {
        databaseLock.lock()
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        var isSuccess = false
        do {
            try connection.run(operation)
            isSuccess = true
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return isSuccess
    }
    
    public func runSelectOperator(_ operation: QueryType) -> AnySequence<Row>? {
        databaseLock.lock()
        guard let connection = self.connection else {
            return handleDatabaseError(DatabaseError.unconnection)
        }
        var sequence: AnySequence<Row>?
        do {
            sequence = try connection.prepare(operation)
        } catch {
            return handleDatabaseError(error)
        }
        defer {
            databaseLock.unlock()
        }
        return sequence
    }
}

extension MLDatabaseManager {
    fileprivate func handleDatabaseError(_ error: Error) -> Bool {
        MolueLogger.failure.message(error)
        return false
    }
    fileprivate func handleDatabaseError(_ error: Error) -> AnySequence<Row>? {
        MolueLogger.failure.message(error)
        return nil
    }
}
