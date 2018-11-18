//
//  MolueHomePublicModels.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public struct DangerUnitSectionHeaderModel {
    var unitName: String
    var unitNumber: String
    var unitClass: String
    var unitRisks: [DangerUnitRiskModel]
}

public enum DangerUnitRiskStatus {
    case success
    case failure
    case waiting
}

public struct DangerUnitRiskModel {
    var riskName: String
    var riskHead: String
    var riskLevel: String
    var riskClass: String
    var riskReason: String
    var accidentType: String
    var dependence: String
    var riskMeasure: [String]
    var headPhone: String
    var responseUnit: String
    var riskRemarks: String
    var riskStatus: String
}
