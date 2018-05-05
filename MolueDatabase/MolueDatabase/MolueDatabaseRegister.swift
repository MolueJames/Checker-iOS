//
//  MolueDatabaseRegister.swift
//  MolueDatabase
//
//  Created by James on 2018/5/5.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
public class MLDatabaseRegister {
    private static var list = [MLDatabaseProtocol.Type]()
    private static let databaseLock = NSLock()
    
    public static func addDatabaseTarget(_ target: MLDatabaseProtocol.Type) {
        databaseLock.lock()
        list.append(target)
        databaseLock.unlock()
    }
    
    public static func excuteProtocols () {
        databaseLock.lock()
        for aProtocol in list {
            aProtocol.createOperation()
        }
        databaseLock.unlock()
    }
}
