//
//  MolueUser.swift
//  MolueDatabase
//
//  Created by James on 2018/4/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import SQLite
public class users: NSObject {
    var aname: String?
    var aemail: String?
    var aid: String?
}

extension users {
    private static let table_users = Table("users") //表名
    private static let id = Expression<String>("id")      //主键
    private static let name = Expression<String>("name")  //列表1
    private static let email = Expression<String>("email") //列表2
    
    private static let columnList = [databaseColumn(colunm: id, key: "aid"),databaseColumn(colunm: name, key: "aname"),databaseColumn(colunm: email, key: "aemail")]
    private static let valuesList = ["aname"]
    
    public static func createOperation() {
        let operation = table_users.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        }
        MolueDBManager.shared.runCreateOperator(operation)
    }
    
    public static func selectOperation() -> [users] {
        let list = MolueDBManager.shared.runSelectOperator(table_users)
        return MolueDBHelper.transferSequence(list) { (row) -> users? in
            return updateValueForRow(row)
        }
    }
    
    public static func updateValueForRow(_ row: Row) -> users? {
        do {
            let user = users()
            for column in columnList {
                let value = try row.get(column.colunm)
                user.setValue(value, forKey:column.key)
            }
            return user
        } catch {
            return nil
        }
    }
}

public struct databaseColumn {
    var colunm:Expression<String>
    var key: String
}
    

