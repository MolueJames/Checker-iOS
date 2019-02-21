//
//  MLRiskUitModel.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

/// TODO: 改变部分属性, 和删除部分类
public class MLRiskUnitAccident: Mappable {
    public required init?(map: Map) {
        code        <- map["code"]
        description <- map["description"]
        accidentId  <- map["id"]
        name        <- map["name"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var code: String?
    public var description: String?
    public var accidentId: Int?
    public var name: String?
}

public class MLRiskUnitSolution: Mappable {
    public required init?(map: Map) {
        rightAnswer <- map["right_answer"]
        answers <- map["answers"]
        solutionId <- map["id"]
        order <- map["order"]
        score <- map["score"]
        title <- map["title"]
        risk <- map["risk"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var answers: String?
    public var solutionId: Int?
    public var order: Int?
    public var rightAnswer: String?
    public var risk: Int?
    public var score: Int?
    public var title: String?
}

//MARK:
public class MLRiskClassification: Mappable {
    public required init?(map: Map) {
        hasChildren <- map["has_children"]
        children <- map["children"]
        code <- map["code"]
        name <- map["name"]
    }
    
    public func mapping(map: Map) {
        
    }
    public var children: [MLRiskClassification]?
    public var code: String?
    public var name: String?
    public var hasChildren: Bool?
}

//MARK: 用户每日的任务列表
public class MLDailyCheckPlan: Mappable {
    public required init?(map: Map) {
        enterprise <- map["enterprise"]
        cycleType <- map["cycle_type"]
        unitCode <- map["unit_code"]
        unitName <- map["unit_name"]
        category <- map["category"]
        planCycle <- map["cycle"]
        created <- map["created"]
        updated <- map["updated"]
        status <- map["status"]
        tasks <- map["tasks"]
        planId <- map["id"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var enterprise: Int?
    public var planId: Int?
    public var created: String?
    public var tasks: [MLDailyCheckTask]?
    public var status: String?
    public var cycleType: String?
    public var updated: String?
    public var planCycle: Int?
    public var unitCode: String?
    public var unitName: String?
    public var category: MLCheckCategory?
}

//MARK: 用户每日的任务风险单元的类别
public class MLCheckCategory: Mappable {
    public required init?(map: Map) {
        categoryId <- map["id"]
        title <- map["title"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var categoryId: Int?
    public var title: String?
}

//MARK: 用户每日的任务详情
public class MLDailyCheckTask: Mappable {
    public required init?(map: Map) {
        expiration <- map["time_of_expiration"]
        enterprise <- map["enterprise"]
        finish <- map["time_of_finish"]
        start <- map["time_of_start"]
        updated <- map["updated"]
        created <- map["created"]
        status <- map["status"]
        items <- map["items"]
        taskId <- map["id"]
        risk <- map["risk"]
    }
    
    public func mapping(map: Map) {
        expiration >>> map["time_of_expiration"]
        finish >>> map["time_of_finish"]
        start >>> map["time_of_start"]
        updated >>> map["updated"]
        status >>> map["status"]
        items >>> map["items"]
        taskId >>> map["id"]
    }
    
    public var taskId: String?
    public var risk: MLRiskPointDetail?
    public var status: String?
    public var created: String?
    public var enterprise: Int?
    public var items: [MLTaskAttachment]?
    public var updated: String?
    public var expiration: String?
    public var finish: String?
    public var start: String?
}

public class MLRiskUnitDetail: Mappable {
    public required init?(map: Map) {
        enterprise <- map["enterprise"]
        unitCode <- map["unit_code"]
        unitName <- map["unit_name"]
        category <- map["category"]
        created <- map["created"]
        updated <- map["updated"]
        status <- map["status"]
        risks <- map["risks"]
        unitId <- map["id"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var unitId: Int?
    public var unitCode: String?
    public var unitName: String?
    public var category: MLCheckCategory?
    public var risks: [MLRiskPointDetail]?
    public var status: String?
    public var created: String?
    public var updated: String?
    public var enterprise: Int?
}

//MARK: 用户每日的任务单元
public class MLRiskPointDetail: Mappable {
    public required init?(map: Map) {
        calculation <- map["method_of_calculation"]
        classification <- map["classification"]
        responseUnit <- map["response_unit"]
        person <- map["response_person"]
        contact <- map["contact_phone"]
        aExtension <- map["extension"]
        accidents <- map["accidents"]
        solutions <- map["solutions"]
        standards <- map["standards"]
        riskUnit <- map["risk_unit"]
        updated <- map["updated"]
        created <- map["created"]
        dangers <- map["dangers"]
        unitCode <- map["code"]
        unitName <- map["name"]
        remark <- map["remark"]
        status <- map["status"]
        level <- map["level"]
        grade <- map["grade"]
        unitId <- map["id"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var unitId: Int?
    public var unitCode: String?
    public var unitName: String?
    public var person: String?
    public var level: String?
    public var calculation: String?
    public var remark: String?
    public var riskUnit: Int?
    public var responseUnit: String?
    public var grade: Int?
    public var aExtension: String?
    public var dangers: String?
    public var created: String?
    public var contact: String?
    public var standards: String?
    public var status: String?
    public var updated: String?
    public var solutions: [MLRiskUnitSolution]?
    public var accidents: [MLRiskUnitAccident]?
    public var classification: [MLRiskClassification]?
}

public class MLTaskAttachment: Mappable {
    public required init?(map: Map) {
        committed <- map["time_committed"]
        rightAnswer <- map["right_answer"]
        attachments <- map["attachments"]
        content <- map["content"]
        attachmentId <- map["id"]
        answers <- map["answers"]
        taskId <- map["task_id"]
        remark <- map["remark"]
        result <- map["result"]
        score <- map["score"]
    }
    public required init() {
        
    }
    public func mapping(map: Map) {
        attachments >>> map["attachments"]
        attachmentId >>> map["id"]
        result >>> map["result"]
    }
    
    public var attachments: [MLAttachmentDetail]?
    public var content: String?
    public var attachmentId: String?
    public var remark: String?
    public var result: String?
    public var taskId: String?
    public var committed: String?
    public var rightAnswer: String?
    public var score: String?
    public var answers: String?
}

public class MLAttachmentDetail: Mappable {
    public required init?(map: Map) {
        screenName <- map["screen_name"]
        detailId <- map["id"]
        urlPath <- map["url"]
        type <- map["type"]
    }
    
    public init(_ image: UIImage? = nil) {
        self.image = image
    }
    
    public func mapping(map: Map) {
        screenName >>> map["screen_name"]
        detailId >>> map["id"]
        urlPath >>> map["url"]
        type >>> map["type"]
    }
    
    public var detailId: String?
    public var screenName: String?
    public var image: UIImage?
    public var type: String?
    public var urlPath: String?
    
    public func updateAttachment(with result: Any?) {
        do {
            let result = try (result as? [String : String]).unwrap()
            self.detailId = result["id"]
            self.screenName = result["screen_name"]
            self.type = result["type"]
            self.urlPath = result["url"]
        } catch {
            MolueLogger.network.message(error)
        }
    }
}
