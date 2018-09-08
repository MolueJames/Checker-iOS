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
import MolueDatabase
public class MolueUsers: Codable, MLDatabaseProtocol {
    var name: String?
    var email: String?
    var id: String?
    var subUser: [MolueUsers]?
    public init() {
    }
}

extension MolueUsers {
    public static var table_name = Table("users")
    
    public static let id = Expression<String>("id")      //主键
    public static let name = Expression<String>("name")  //列表1
    public static let email = Expression<String>("email") //列表2
    
    public static func createOperation() {
        let operation = table_name.create (ifNotExists:true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        }
        MLDatabaseManager.shared.runCreateOperator(operation)
    }
    
    
}



