//
//  MolueUserService.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public struct AccountService {
    public static func appVersion(device: String, version: String) -> MolueProviderModel{
        let task = MolueProvideTask.URLEncode(parameters: ["version": version, "device": device]).toTask()
        return MolueProviderModel.init(path: "api/app/version", method: .get, task: task)
    }
}
