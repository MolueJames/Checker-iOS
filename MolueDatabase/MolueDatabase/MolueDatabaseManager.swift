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
private let databaseQueue = DispatchQueue(label: "MLConnectionQueue")

let single = MLDatabaseManager()
public class MLDatabaseManager {
    public static var shared : MLDatabaseManager {
        return single
    }
   
    private (set) var connection: Connection?
    
    @discardableResult
    public func doConnection(_ fileName: String) -> Bool {
        return databaseQueue.sync {
            do {
                let pathList = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = try pathList.first.unwrap()
                connection = try Connection("\(path)/\(fileName).sqlite3")
                MolueLogger.database.message("file path: \(path)/\(fileName).sqlite3")
                return true
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
        }
    }
}

extension MLDatabaseManager {
    
    @discardableResult
    public func runUpdataOperator(_ operation: Update) -> Bool {
        return databaseQueue.sync {
            var isSuccess = false
            do {
                let connection = try self.connection.unwrap()
                try connection.run(operation)
                isSuccess = true
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
            return isSuccess
        }
    }
    
    @discardableResult
    public func runInsertOperator(_ operation: Insert) -> Bool {
        return databaseQueue.sync {
            var isSuccess = false
            do {
                let connection = try self.connection.unwrap()
                try connection.run(operation)
                isSuccess = true
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
            return isSuccess
        }
    }
    
    @discardableResult
    public func runDeleteOperator(_ operation: Delete) -> Bool {
        return databaseQueue.sync {
            var isSuccess = false
            do {
                let connection = try self.connection.unwrap()
                try connection.run(operation)
                isSuccess = true
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
            return isSuccess
        }
    }
    
    @discardableResult
    public func runCreateOperator(_ operation: String) -> Bool {
        return databaseQueue.sync {
            var isSuccess = false
            do {
                let connection = try self.connection.unwrap()
                try connection.run(operation)
                isSuccess = true
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
            return isSuccess
        }
    }
    
    public func runSelectOperator(_ operation: QueryType) -> AnySequence<Row>? {
        return databaseQueue.sync {
            var sequence: AnySequence<Row>?
            do {
                let connection = try self.connection.unwrap()
                sequence = try connection.prepare(operation)
            } catch is MolueNilError {
                return handleDatabaseError(DatabaseError.databasePath)
            } catch {
                return handleDatabaseError(error)
            }
            return sequence
        }
    }
}

extension MLDatabaseManager {
    fileprivate func handleDatabaseError(_ error: Error) -> Bool {
        MolueLogger.failure.message(error)
        return false
    }
    fileprivate func handleDatabaseError(_ error: Error) -> AnySequence<Row>? {
        return MolueLogger.failure.returnNil(error)
    }
}
