//
//  MolueOauthModel+SQLite.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import MolueDatabase
import SQLite

extension MolueOauthModel: MLDatabaseProtocol {
    public static var table_name = Table("MolueOauthTable")
    private static let access_token  = Expression<String?>("access_token")
    private static let expires_date  = Expression<String?>("expires_date")
    private static let refresh_token = Expression<String?>("refresh_token")
    private static let user_scope    = Expression<String?>("scope")
    private static let token_type    = Expression<String?>("token_type")

    public static func createOperation() {
        let operation = table_name.create (ifNotExists: true){ t in
            t.column(access_token)
            t.column(token_type)
            t.column(user_scope)
            t.column(expires_date)
            t.column(refresh_token)
        }
        MLDatabaseManager.shared.runCreateOperator(operation)
    }
    
    private static var OauthItem: MolueOauthModel?
    
    public static func updateOauthItem(with newValue: MolueOauthModel) {
        let existedList = self.selectObjectOperation()
        self.updateDatabaseOauth(with: newValue, oldValues: existedList)
        MolueOauthModel.OauthItem = newValue
    }
    
    private static func updateDatabaseOauth(with newValue: MolueOauthModel, oldValues: [MolueOauthModel]?) {
        if let oldValue = oldValues?.first {
            let query = table_name.filter(refresh_token == oldValue.refresh_token)
            self.updateObjectOperation(newValue, query: query)
        } else {
            self.insertObjectOperation(newValue)
        }
    }
    
    public static func queryOauthItem() -> MolueOauthModel? {
        if MolueOauthModel.OauthItem.isSome() {
            return MolueOauthModel.OauthItem
        } else {
            return self.queryDatabaseOauth()
        }
    }
    
    private static func queryDatabaseOauth() -> MolueOauthModel? {
        do {
            let existedList = try self.selectObjectOperation().unwrap()
            self.OauthItem = try existedList.first.unwrap()
            return self.OauthItem
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }
}
