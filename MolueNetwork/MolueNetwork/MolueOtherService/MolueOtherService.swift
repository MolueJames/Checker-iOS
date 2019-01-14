//
//  MolueOtherService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2019-01-14.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import Foundation

public struct MolueOtherService {
    public static func queryAdvertisement(with position: String, platform: String) -> MolueDataRequest {
        let parameters = ["position" : position, "platform" : platform]
        let path = "api/advertisement/advertisements/"
        return MolueDataRequest(parameter: parameters, method: .get, path: path)
    }
}
