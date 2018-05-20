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

public enum AccountService: MolueServiceProtocol {

    case appVersion(device:String, version:String)

    public func providerModel() -> MolueProviderModel {
        switch self {
        case .appVersion(let device, let version):
            let aTask = MolueProvideTask.URLEncode(parameters: ["version": version, "device": device]).toTask()
            return MolueProviderModel.init(path: "api/app/version", method: .get, task: aTask)
        }
    }
}
