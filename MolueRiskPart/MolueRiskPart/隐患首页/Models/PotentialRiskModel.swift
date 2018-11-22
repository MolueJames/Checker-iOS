//
//  PotentialRiskModel.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

enum PotentialRiskStatus {
    case never //待整改
    case finish //已整改
    case closed //已关闭
}

enum PotentialRiskChannel {
    case enterprise
    case government
}

enum PotentialRiskLevel {
    case serious
    case general
}

struct PotentialRiskModel {
    var status: PotentialRiskStatus?
    var channel: PotentialRiskChannel?
    var level: PotentialRiskLevel?
    var checkedDate: String?
    var finishDate: String?
    var closedData: String?
    
    var potentialRiskPhotos: [UIImage]?
    var finishedRiskPhotos: [UIImage]?
    var riskDetail: String?
    var finishDetail: String?
    
    var arrangeModel: [Any]?
}


