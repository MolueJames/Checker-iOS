//
//  MolueHiddenPeril.swift
//  MolueMediator
//
//  Created by MolueJames on 2019/1/9.
//  Copyright © 2019 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public class MLHiddenPerilItem: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        rectification <- map["need_rectification"]
        classification <- map["classification"]
        approvedUser <- map["user_of_approved"]
        rectifyDate <- map["rectify_date"]
        attachments <- map["attachments"]
        enterpriseId <- map["enterprise_id"]
        createdUser <- map["user_of_created"]
        approvedDate <- map["date_approved"]
        perilId <- map["id"]
        status <- map["status"]
        grade <- map["grade"]
        riskId <- map["risk_id"]
        source <- map["source"]
        updated <- map["updated"]
        perilMemo <- map["memo"]
    }
    
    public var perilId: String?
    public var status: String?
    public var grade: String?
    public var classification: MLRiskClassification?
    public var source: String?
    public var perilMemo: String?
    public var rectification: Bool?
    public var rectifyDate: String?
    public var attachments: [MLAttachmentDetail]?
    public var enterpriseId: String?
    public var riskId: String?
    public var createdUser: MolueUserInfo?
    public var approvedDate: String?
    public var updated: String?
    public var approvedUser: MolueUserInfo?
}

public enum PotentialRiskChannel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .enterprise:
            return "企业自查"
        case .government:
            return "政府检查"
        }
    }
    
    case enterprise
    case government
}

public enum PotentialRiskLevel: CaseIterable, CustomStringConvertible {
    public var description: String {
        switch self {
        case .serious:
            return "重大事故隐患"
        case .general:
            return "一般事故隐患"
        case .higher:
            return "较高事故隐患"
        case .atLower:
            return "较低事故隐患"
        }
    }
    
    case serious
    case higher
    case general
    case atLower
}
