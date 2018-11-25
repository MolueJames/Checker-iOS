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
    public var riskName: String?
    public var riskHead: String?
    public var riskLevel: String?
    public var riskClass: String?
    public var riskReason: String?
    public var accidentType: String?
    public var dependence: String?
    public var riskMeasure: [String]?
    public var headPhone: String?
    public var responseUnit: String?
    public var riskRemarks: String?
    public var riskStatus: String?
    public init() {}
}
