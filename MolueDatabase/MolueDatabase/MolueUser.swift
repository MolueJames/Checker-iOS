//
//  MolueUser.swift
//  MolueDatabase
//
//  Created by James on 2018/4/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import SQLite
import MolueUtilities

public struct users: Codable {
    var name: String?
    var email: String?
    var id: String?
}

extension users: MLDatabaseProtocol {
    public static var table_name = Table("users")
    
    private static let id = Expression<String>("id")      //主键
    private static let name = Expression<String>("name")  //列表1
    private static let email = Expression<String>("email") //列表2
    
    public static func createOperation() {
        let operation = table_name.create (ifNotExists:true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        }
        MLDatabaseManager.shared.runCreateOperator(operation)
    }
}



