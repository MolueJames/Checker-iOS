//
//  UserInfoCenterModel.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
enum UserInfoCenterMethod: CaseIterable {
    case version
    case message
    case aboutUs
    
    func toMethodDetail() -> (name: String, image: String, detail: String) {
        switch self {
        case .message:
        return ("我的信息", "mine_mineInfo_message", "")
        case .version:
        return ("当前版本", "mine_mineInfo_update", "v.1.0.0")
        case .aboutUs:
        return ("关于我们", "mine_mineInfo_aboutUs", "")
        }
    }
}
