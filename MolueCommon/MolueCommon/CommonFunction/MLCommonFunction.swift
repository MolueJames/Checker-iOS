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

public class MLUserLogicHelper {
    public static func updateDatabasePath(with path: String?) {
        let keychain = Keychain(service: databaseSevice)
        keychain["databasePath"] = path
    }
    
    public static func queryDatabasePath() -> String? {
        let keychain = Keychain(service: databaseSevice)
        return keychain["databasePath"]
    }
}
