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
    case finsh //已整改
    case close //已关闭
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
    var date: String?
    var detail: String?
    
    static func defaultValue() -> [PotentialRiskModel] {
        let value1 = PotentialRiskModel(status: .never, channel: .enterprise, level: .serious, date: "06-08", detail: "占用")
        let value2 = PotentialRiskModel(status: .never, channel: .enterprise, level: .serious, date: "06-08", detail: "占用")
        let value3 = PotentialRiskModel(status: .never, channel: .enterprise, level: .serious, date: "06-08", detail: "占用")
        return [value1, value2, value3]
    }
}


