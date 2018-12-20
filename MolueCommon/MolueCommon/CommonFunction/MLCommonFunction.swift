//
//  MLCommonFunction.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import KeychainAccess
import MolueMediator
import MolueDatabase

public struct MLCommonFunction {
    public static func makeTelephoneCall(_ phone: String) {
        do {
            let url = try URL(string: "tel:" + phone).unwrap()
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } catch {
            MolueLogger.failure.error(error)
        }
    }
}

private let databaseSevice: String = "com.safety-saas.db.path"

public class MolueUserLogic {
    
    public static func doConnectWithDatabase(path: String) {
        MolueUserLogicUtily.updateDatabasePath(path)
        MLDatabaseManager.shared.doConnection(path)
        MolueUserLogicUtily.doDatabaseTableRegist()
    }
    
    public static func disconnectWithDatabase() {
        MolueUserLogicUtily.updateDatabasePath(nil)
        MLDatabaseManager.shared.disconnect()
    }
    
    public static func connectWithLastDatabase() throws {
        do {
            let path =  MolueUserLogicUtily.queryDatabasePath()
            try MLDatabaseManager.shared.doConnection(path.unwrap())
            MolueUserLogicUtily.doDatabaseTableRegist()
        } catch { throw error }
    }
    
}

fileprivate struct MolueUserLogicUtily {
    fileprivate static func updateDatabasePath(_ path: String?) {
        let keychain = Keychain(service: databaseSevice)
        keychain["databasePath"] = path
    }
    
    fileprivate static func queryDatabasePath() -> String? {
        let keychain = Keychain(service: databaseSevice)
        return keychain["databasePath"]
    }
    
    fileprivate static func doDatabaseTableRegist() {
        MLDatabaseRegister.addDatabaseTarget(MolueOauthModel.self)
        MLDatabaseRegister.excuteProtocols()
    }
}
