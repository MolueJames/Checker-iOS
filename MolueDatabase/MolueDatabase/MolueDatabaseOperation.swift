//
//  MolueDatabaseOperation.swift
//  MolueDatabase
//
//  Created by James on 2018/5/5.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import SQLite
import MolueUtilities

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
