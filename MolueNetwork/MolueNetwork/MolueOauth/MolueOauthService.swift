//
//  MolueOauthService.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public struct MolueOauthService {
    public static func doLogin(username: String, password: String, delegate: MolueActivityDelegate? = nil) -> MolueRequestManager {
        let header = MolueOauthHelper.authHeader()
        let parameter = ["username":username, "password":password, "grant_type":"password"]
        let request = MolueDataRequest.init(parameter:parameter, method: .post, path: "oauth/token/", headers: header)
        return MolueRequestManager.init(request: request, delegate: delegate)
    }
}
