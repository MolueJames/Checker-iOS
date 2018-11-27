//
//  AppRiskDocument.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/27.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

fileprivate let single = AppRiskDocument()
public class AppRiskDocument {
    public static var shared: AppRiskDocument {
        return single
    }
    
    public var riskList: [PotentialRiskModel] = [PotentialRiskModel]()
    
    public let riskClassList: [String] = ["资质执照 - 缺少资质证照" , "资质执照 - 资质证照未合法有效", "重大危险源管理 - 重大危险源辨识与评估缺陷", "个体防护装备 - 个体防护装备配备不足", "职业健康 - 职业病危害因素告知缺陷", "安全投入 - 安全投入不足"]
    
    public let riskUnitList: [String] = ["生产车间1", "生产车间2"]
}
