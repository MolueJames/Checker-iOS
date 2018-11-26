//
//  MolueHomePublicModels.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public struct DangerUnitSectionHeaderModel {
    public var unitName: String?
    public var unitNumber: String?
    public var unitClass: String?
    public var unitRisks: [DangerUnitRiskModel]?
    public init() {}
}

public enum DangerUnitRiskStatus {
    case success
    case failure
    case waiting
}

public struct DangerUnitRiskModel {
    public var riskName: String? //风险点名称
    public var riskHead: String? //负责人
    public var riskLevel: String? //风险等级
    public var riskClass: String? //涉及隐患分类
    public var riskReason: String? //危险因素
    public var accidentType: String? //可能发生事故
    public var dependence: String? //依据的标准
    public var riskMeasure: [String]? //管控措施
    public var headPhone: String? //联系人手机号
    public var responseUnit: String? //责任单位
    public var riskRemarks: String? //备注
    public var riskStatus: String? //风险点状态
    public init() {}
}

public struct RiskMeasureModel {
    public var measureName: String?
    public var measureState: String?
    public var riskModel: PotentialRiskModel?
}
