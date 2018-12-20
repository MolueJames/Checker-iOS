//
//  MLRiskUitModel.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: 用户需要检查的单元类别的详情 TO DELETE
public class MLRiskUnitCategoryModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        description <- map["description"]
        categoryId  <- map["id"]
        prefix      <- map["prefix"]
        title       <- map["title"]
    }
    
    public var description: String?
    public var categoryId: Int?
    public var prefix: String?
    public var title: String?
}

//MARK: 用户需要检查的风险点的详情 TO DELETE
public class MLRiskTaskDetailModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code            <- map["code"]
        phone           <- map["contact_phone"]
        created         <- map["created"]
        dangers         <- map["dangers"]
        extensions      <- map["extension"]
        grade           <- map["grade"]
        taskId          <- map["id"]
        calculation     <- map["method_of_calculation"]
        name            <- map["name"]
        remark          <- map["remark"]
        person          <- map["response_person"]
        unit            <- map["response_unit"]
        risk_unit       <- map["risk_unit"]
        standards       <- map["standards"]
        status          <- map["status"]
        updated         <- map["updated"]
        accidents       <- map["accidents"]
        classification  <- map["classification"]
        level = MLUnitRiskLevel.map(map["level"].value())
    }
    
    public var code: String?
    public var phone: String?
    public var created: String?
    public var dangers: String?
    public var extensions: String?
    public var grade: String?
    public var taskId: Int?
    public var level: MLUnitRiskLevel = .lower
    public var calculation: String?
    public var name: String?
    public var remark: String?
    public var person: String?
    public var unit: String?
    public var risk_unit: Int?
    public var standards: String?
    public var status: String?
    public var updated: String?
    public var accidents: [MLRiskAccidentModel]?
    public var classification: [MLRiskClassificationModel]?
    
    
}

// TO CHANGE
public class MLRiskAccidentModel: Mappable {
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

//MARK:
public class MLRiskClassificationModel: Mappable {
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
    }
    
    public var taskId: String?
    public var risk: MLRiskDetailUnit?
    public var status: String?
}

//MARK: 用户每日的任务单元
public class MLRiskDetailUnit: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        unitId <- map["id"]
        person <- map["response_person"]
        unitCode <- map["code"]
        unitName <- map["name"]
        let aLevel: String? = map["level"].value()
        self.level = MLUnitRiskLevel.map(aLevel)
    }
    
    public var unitId: String?
    public var unitCode: String?
    public var unitName: String?
    public var person: String?
    public var level: MLUnitRiskLevel?
}

//MARK: 用户每日的任务单元的风险等级
public enum MLUnitRiskLevel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .normal:
            return "一般风险"
        default:
            return "较低风险"
        }
    }
    
    case normal
    case lower
    case higher
    case large
    
    public static func map(_ value: String?) -> MLUnitRiskLevel {
        switch value {
        case "normal":
            return normal
        default:
            return lower
        }
    }
}

//MARK: 用户需要检查的单元 TO DELETE
public class MLRiskUnitDetailModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        cycle_type <- map["cycle_type"]
        enterprise <- map["enterprise"]
        unit_code  <- map["unit_code"]
        unit_name  <- map["unit_name"]
        category   <- map["category"]
        updated    <- map["updated"]
        status     <- map["status"]
        cycle      <- map["cycle"]
        risks      <- map["risks"]
        unitId     <- map["id"]
    }
    
    public var category: MLRiskUnitCategoryModel?
    public var cycle: Int?
    public var cycle_type: String?
    public var enterprise: Int?
    public var unitId: Int?
    public var risks: [MLRiskTaskDetailModel]?
    public var status: String?
    public var unit_code: String?
    public var unit_name: String?
    public var updated: String?
}
