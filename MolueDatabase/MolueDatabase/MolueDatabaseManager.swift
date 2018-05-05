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
public class MLDatabaseManager: DatabaseErrorProtocol {
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

protocol DatabaseErrorProtocol {
    func handleDatabaseError(_ error: Error) -> AnySequence<Row>?
    
    func handleDatabaseError(_ error: Error) -> Bool
}

extension DatabaseErrorProtocol {
    public func handleDatabaseError(_ error: Error) -> Bool {
        MolueLogger.failure.message(error)
        return false
    }
    public func handleDatabaseError(_ error: Error) -> AnySequence<Row>? {
        MolueLogger.failure.message(error)
        return nil
    }
}
