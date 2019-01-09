//
//  MolueUserInfoService.swift
//  MolueNetwork
//
//  Created by MolueJames on 2018/12/13.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

public struct MolueUserService {
    public static func queryUserInformation() -> MolueDataRequest {
        return MolueDataRequest(parameter: nil, method: .get, path: "api/auths/info/")
    }
}
