//
//  MLInspectionTaskItem.swift
//  MolueMediator
//
//  Created by MolueJames on 2019/2/21.
//  Copyright © 2019 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public class MLInspectionTask: Mappable {
    public required init?(map: Map) {
        taskId <- map["id"]
        enterprise <- map["enterprise"]
        owner <- map["owner"]
        aExtension <- map["extension"]
        assistUser <- map["assist_user"]
        publishUser <- map["publish_user"]
        taskItems <- map["items"]
        updated <- map["updated"]
        created <- map["created"]
        taskType <- map["type"]
        taskName <- map["name"]
        status <- map["status"]
        expiredDate <- map["date_expired"]
        publishedDate <- map["date_published"]
        inspectedDate <- map["date_inspected"]
        result <- map["result"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        checkLocation <- map["check_location"]
        adminArea <- map["admin_area"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var taskId: String?
    public var enterprise: MLEnterpriseItem?
    public var owner: MolueUserInfo?
    public var aExtension: MLTaskExtension?
    public var assistUser: MolueUserInfo?
    public var publishUser: MolueUserInfo?
    public var taskItems: [MLInspectionTaskItem]?
    public var updated: Date?
    public var created: Date?
    public var taskType: String?
    public var taskName: String?
    public var status: String?
    public var expiredDate: String?
    public var publishedDate: String?
    public var inspectedDate: String?
    public var result: String? //
    public var longitude: Double?
    public var latitude: Double?
    public var checkLocation: String?
    public var adminArea: String?
    
}

public class MLInspectionTaskItem: Mappable {
    public required init?(map: Map) {
        itemId <- map["id"]
        content <- map["content"]
        result <- map["result"]
        remark <- map["remark"]
        order <- map["order"]
        taskId <- map["task"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var itemId: String?
    public var content: MLTaskItemContent?
    public var result: String? //
    public var remark: String? //
    public var order: Int?
    public var taskId: String?
}

public class MLTaskItemContent: Mappable {
    public required init?(map: Map) {
        contentId <- map["id"]
        category <- map["category"]
        contentCode <- map["code"]
        contentItem <- map["content"]
        checkWay <- map["check_way"]
        riskLevel <- map["risk_level"]
        negativeDetail <- map["negative_detail"]
        contentLaw <- map["law"]
        comment <- map["comment"]
        contentMemo <- map["memo"]
        alive <- map["alive"]
        answers <- map["answers"]
        rightAnswer <- map["right_answer"]
        canIgnore <- map["can_ignore"]
        needPhoto <- map["need_photo"]
        score <- map["score"]
        standard <- map["standard"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var contentId: Int?
    public var category: MLContentCategory?
    public var contentCode: String?
    public var contentItem: String?
    public var checkWay: String?
    public var riskLevel: String?
    public var negativeDetail: String?
    public var contentLaw: String?
    public var comment: String?
    public var contentMemo: String?
    public var alive: Bool?
    public var answers: String?
    public var rightAnswer: String?
    public var canIgnore: Bool?
    public var needPhoto: Bool?
    public var score: Int?
    public var standard: String?
}

public class MLContentCategory: Mappable {
    public required init?(map: Map) {
        categoryId <- map["id"]
        title <- map["title"]
        parentId <- map["parent"]
    }
    
    public func mapping(map: Map) {
    
    }
    
    public var categoryId: Int?
    public var title: String?
    public var parentId: Int?
}

public class MLTaskExtension: Mappable {
    public required init?(map: Map) {
        riskId <- map["risk_id"]
        riskName <- map["risk_name"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var riskId: Int?
    public var riskName: String?
}

public class MLEnterpriseItem: Mappable {
    public required init?(map: Map) {
        enterpriseId <- map["id"]
        enterpriseName <- map["name"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var enterpriseName: String?
    public var enterpriseId: Int?
}
