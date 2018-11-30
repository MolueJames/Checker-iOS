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
    private static var oauthToken: String = String()
    
    public static func queryAuthHeader() -> [String : String]? {
        do {
            let header = Request.authorizationHeader(user: key, password: secret)
            let authHeader = try header.unwrap()
            return [authHeader.key: authHeader.value]
        } catch {
            return MolueLogger.network.returnNil(error)
        }
    }
    
//    public static func storeTokenHeader() -> [String : String]? {
//
//    }

    public static func storeOauthToken(_ token: String) {
        self.oauthToken = token
    }

    public static func queryOauthToken() -> String {
        return self.oauthToken
    }
}
