//
//  MolueUserInfoModel+SQLite.swift
//  MolueMediator
//
//  Created by JamesCheng on 2018-12-21.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities
import MolueDatabase
import SQLite

extension MolueUserInfo: MLDatabaseProtocol {
    public static var table_name = Table("MolueUserTable")
    private static let adminAreaId  = Expression<String?>("adminAreaId")
    private static let dateJoined   = Expression<String?>("dateJoined")
    private static let userEmail    = Expression<String?>("userEmail")
    private static let enterpriseId = Expression<Int?>("enterpriseId")
    private static let lastLogin    = Expression<String?>("lastLogin")
    private static let lastName     = Expression<String?>("lastName")
    private static let userMobile   = Expression<String?>("userMobile")
    private static let nameUser     = Expression<String?>("nameUser")
    private static let userOrder    = Expression<Int?>("userOrder")
    private static let userPhone    = Expression<String?>("userPhone")
    private static let position     = Expression<String?>("position")
    private static let profile      = Expression<String?>("profile")
    private static let userRole     = Expression<String?>("userRole")
    private static let screenName   = Expression<String?>("screenName")
    private static let username     = Expression<String?>("username")
    private static let permissions  = Expression<String?>("permissions")
    private static let userID       = Expression<Int>("userID")
    
    public static func createOperation() {
        let operation = table_name.create (ifNotExists: true){ t in
            t.column(userID, primaryKey: true)
            t.column(adminAreaId)
            t.column(dateJoined)
            t.column(userEmail)
            t.column(enterpriseId)
            t.column(lastLogin)
            t.column(lastName)
            t.column(userMobile)
            t.column(nameUser)
            t.column(userOrder)
            t.column(userPhone)
            t.column(position)
            t.column(profile)
            t.column(userRole)
            t.column(screenName)
            t.column(username)
            t.column(permissions)
        }
        MLDatabaseManager.shared.runCreateOperator(operation)
    }
    
    private static var current: MolueUserInfo?
    
    public static func updateUserInfo(with newValue: MolueUserInfo) {
        let existedList = self.selectObjectOperation()
        self.updateDatabaseUser(with: newValue, oldValues: existedList)
        MolueUserInfo.current = newValue
    }
    
    private static func updateDatabaseUser(with newValue: MolueUserInfo, oldValues: [MolueUserInfo]?) {
        do {
            let oldValue = try oldValues.unwrap().first.unwrap()
            do {
                let userId: Int = try oldValue.userID.unwrap()
                let query = table_name.filter(userID == userId)
                self.updateObjectOperation(newValue, query: query)
            } catch {
                MolueLogger.database.message(error)
            }
        } catch {
            self.insertObjectOperation(newValue)
        }
    }
    
    public static func queryUserInfo() -> MolueUserInfo? {
        if MolueUserInfo.current.isSome() {
            return MolueUserInfo.current
        } else {
            return self.queryDatabaseUser()
        }
    }
    
    private static func queryDatabaseUser() -> MolueUserInfo? {
        do {
            let existedList = try self.selectObjectOperation().unwrap()
            MolueUserInfo.current = try existedList.first.unwrap()
            return MolueUserInfo.current
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }
}
