//
//  MLRiskUitModel.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper

//
public class MLRiskUnitAccident: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code        <- map["code"]
        description <- map["description"]
        accidentId  <- map["id"]
        name        <- map["name"]
    }
    
    public var code: String?
    public var description: String?
    public var accidentId: Int?
    public var name: String?
}

public class MLRiskUnitSolution: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        answers <- map["answers"]
        solutionId <- map["id"]
        order <- map["order"]
        rightAnswer <- map["right_answer"]
        risk <- map["risk"]
        score <- map["score"]
        title <- map["title"]
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
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
    }
    
    public var code: String?
    public var name: String?
}

//MARK: 用户每日的任务列表
public class MLDailyCheckPlan: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        enterprise     <- map["enterprise"]
        tasks          <- map["tasks"]
        created        <- map["created"]
        updated        <- map["updated"]
        status         <- map["status"]
        planId         <- map["id"]
        cycleType <- map["cycle_type"]
        planCycle <- map["cycle"]
        unitCode <- map["unit_code"]
        unitName <- map["unit_name"]
        category <- map["category"]
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
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        categoryId <- map["id"]
        title <- map["title"]
    }
    
    public var categoryId: Int?
    public var title: String?
}

//MARK: 用户每日的任务详情
public class MLDailyCheckTask: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        taskId <- map["id"]
        risk <- map["risk"]
        status <- map["status"]
        created <- map["created"]
        enterprise <- map["enterprise"]
        items <- map["items"]
        expiration <- map["time_of_expiration"]
        finish <- map["time_of_finish"]
        start <- map["time_of_start"]
        updated <- map["updated"]
    }
    
    public var taskId: String?
    public var risk: MLRiskDetailUnit?
    public var status: String?
    public var created: String?
    public var enterprise: Int?
    public var items: [MLTaskAttachment]?
    public var updated: String?
    public var expiration: String?
    public var finish: String?
    public var start: String?
}

//MARK: 用户每日的任务单元
public class MLRiskDetailUnit: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        unitId <- map["id"]
        person <- map["response_person"]
        unitCode <- map["code"]
        unitName <- map["name"]
        level <- map["level"]
        accidents <- map["accidents"]
        classification <- map["classification"]
        contact <- map["contact_phone"]
        created <- map["created"]
        dangers <- map["dangers"]
        aExtension <- map["extension"]
        grade <- map["grade"]
        calculation <- map["method_of_calculation"]
        remark <- map["remark"]
        responseUnit <- map["response_unit"]
        riskUnit <- map["risk_unit"]
        solutions <- map["solutions"]
        standards <- map["standards"]
        status <- map["status"]
        updated <- map["updated"]
    }
    
    public var unitId: String?
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
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        attachments <- map["attachments"]
        committed <- map["time_committed"]
        content <- map["content"]
        attachmentId <- map["id"]
        remark <- map["remark"]
        result <- map["result"]
        taskId <- map["task"]
    }
    
    public var attachments: String?
    public var content: String?
    public var attachmentId: String?
    public var remark: String?
    public var result: String?
    public var taskId: Int?
    public var committed: String?
}

