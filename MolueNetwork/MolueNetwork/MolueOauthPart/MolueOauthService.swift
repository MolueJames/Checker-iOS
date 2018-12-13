//
//  MolueOauthService.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public struct MolueOauthService {
    
    public static func doLogin(username: String, password: String) -> MolueDataRequest {
        let header = MolueOauthHelper.queryClientInfoHeaders()
        let parameter = ["username": username, "password": password, "grant_type": "password"]
        return MolueDataRequest(parameter:parameter, method: .post, path: "oauth/token/", headers: header)
    }
    
    public static func doRefreshToken(with refreshToken: String?) -> MolueDataRequest {
        let header = MolueOauthHelper.queryClientInfoHeaders()
        let refresh_token: String = refreshToken ?? ""
        let parameter = ["grant_type" : "refresh_token", "refresh_token" : refresh_token]
        return MolueDataRequest(parameter:parameter, method: .post, path: "oauth/token/", headers: header)
    }
}
