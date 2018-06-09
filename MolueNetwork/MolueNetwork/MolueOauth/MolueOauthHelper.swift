//
//  MolueOauthHelper.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Alamofire
import MolueUtilities

let secret = "jEOk3ZLDixlJWPyyoncEbcwp4z3Ij5VG05HfKGORg5357CCWeRnrY86OPFpCPF79FaRiUGHnUcb68uCp5NScHg3z5roBqkVY3eB2LHrEaByULCY4JFMRDvXTa7a3ITq9"
let key = "hj8LAJukEhrs37yPbvXlwX5kG8sk45q0gciIw1Ol"

public struct MolueOauthHelper {
    public static func authHeader() -> [String : String]? {
        let header = Alamofire.Request.authorizationHeader(user: key, password: secret)
        guard let authHeader = header else {
            return MolueLogger.failure.returnNil("the header value is nil")
        }
        return [authHeader.key: authHeader.value]
    }
    
//    public static func tokenHeader() -> [String : String]? {
//
//    }
//
//    public static func storeToken(_ token: [String: String]) {
//
//    }
//
//    public static func oauthToken() -> String {
//
//    }
}
