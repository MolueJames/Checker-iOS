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
    public init() {}
    
    public required init?(map: Map) {
        rectifyBudget <- map["rectification_budget"]
        situationImages <- map["situation_images"]
        verifiedImages <- map["verified_images"]
        rectifyCost <- map["rectification_cost"]
        classification <- map["classification"]
        createdUser <- map["user_of_created"]
        approvedDate <- map["date_approved"]
        enterpriseId <- map["enterprise_id"]
        rectifyDate <- map["rectify_date"]
        attachments <- map["attachments"]
        situations <- map["situations"]
        actions <- map["actions"]
        updated <- map["updated"]
        created <- map["created"]
        perilMemo <- map["memo"]
        status <- map["status"]
        source <- map["source"]
        grade <- map["grade"]
        perilId <- map["id"]
        risk <- map["risk"]
    }
    
    public func mapping(map: Map) {
        classification?.code >>> map["classification_id"]
        attachments >>> map["attachments"]
        situations >>> map["situations"]
        risk?.unitId >>> map["risk_id"]
        perilMemo >>> map["memo"]
        source >>> map["source"]
        grade >>> map["grade"]
    }
    
    public var situationImages: [MLAttachmentDetail]?
    public var classification: MLRiskClassification?
    public var situations: [MLHiddenPerilSituation]?
    public var verifiedImages: [MLAttachmentDetail]?
    public var attachments: [MLAttachmentDetail]?
    public var actions: [MLHiddenPerilAction]?
    public var createdUser: MolueUserInfo?
    public var risk: MLRiskPointDetail?
    public var rectifyBudget: String?
    public var enterpriseId: String?
    public var approvedDate: String?
    public var rectifyDate: String?
    public var rectifyCost: String?
    public var perilMemo: String?
    public var updated: String?
    public var created: String?
    public var perilId: String?
    public var status: String?
    public var source: String? = "C"
    public var grade: String?
}

public class MLHiddenPerilSituation: Mappable {
    public init(_ content: String) {
        self.content = content
    }
    
    public required init?(map: Map) {
        improvement <- map["improvement"]
        orderKey <- map["order_key"]
        content <- map["content"]
        situationId <- map["id"]
        status <- map["status"]
    }
    
    public func mapping(map: Map) {
        improvement >>> map["improvement"]
        content >>> map["content"]
    }
    
    public var improvement: String?
    public var situationId: Int?
    public var content: String?
    public var status: String?
    public var orderKey: Int?
}

public class MLHiddenPerilAction: Mappable {
    public required init() {}
    
    public required init?(map: Map) {
        actionTime <- map["action_time"]
        actionUser <- map["action_user"]
        actionId <- map["id"]
        action <- map["action"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var actionUser: MolueUserInfo?
    public var actionTime: String?
    public var action: String?
    public var actionId: Int?
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
    
    public var toService: String {
        switch self {
        case .serious:
            return "large"
        case .general:
            return "normal"
        case .higher:
            return "high"
        case .atLower:
            return "low"
        }
    }
    
    case serious
    case higher
    case general
    case atLower
}


public enum PotentialRiskStatus: CaseIterable, CustomStringConvertible {
    case create //待整改
    case reform //整改中
    case finish //已整改
    case closed //已关闭
    
    public var description: String {
        switch self {
        case .create:
            return "已登记"
        case .reform:
            return "已安排"
        case .finish:
            return "已完成"
        case .closed:
            return "已验收"
        }
    }
    
    public var toService: String {
        switch self {
        case .create:
            return "created"
        case .reform:
            return "approved"
        case .finish:
            return "done"
        case .closed:
            return "verified"
        }
    }
    
    public static func defaultActions() -> [MLHiddenPerilAction] {
        return self.allCases.compactMap({ status in
            let perilAction = MLHiddenPerilAction()
            perilAction.action = status.toService
            return perilAction
        })
    }
}
