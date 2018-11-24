//
//  AppRiskDocument.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueMediator

fileprivate let single = AppRiskDocument()
class AppRiskDocument {
    public static var shared: AppRiskDocument {
        return single
    }
    
    var riskList: [PotentialRiskModel] = [PotentialRiskModel]()
    
    let riskClassList: [String] = ["资质执照 - 缺少资质证照" , "资质执照 - 资质证照未合法有效", "重大危险源管理 - 重大危险源辨识与评估缺陷", "个体防护装备 - 个体防护装备配备不足", "职业健康 - 职业病危害因素告知缺陷", "安全投入 - 安全投入不足"]
    
    let riskUnitList: [String] = ["化学品仓库", "原料仓库", "电镀车间", "空压机房", "大宗气站", "生产车间"]
}
