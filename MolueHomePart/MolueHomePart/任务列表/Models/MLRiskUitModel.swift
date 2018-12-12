//
//  MLRiskUitModel.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper

//MARK: 用户需要检查的单元类别的详情
public class MLRiskUnitCategoryModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        description <- map["description"]
        categoryId <- map["id"]
        prefix <- map["prefix"]
        title <- map["title"]
    }
    
    var description: String?
    var categoryId: Int?
    var prefix: String?
    var title: String?
}

//MARK: 用户需要检查的风险点的详情
public class MLRiskTaskDetailModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["code"]
        contact_phone <- map["contact_phone"]
        created <- map["created"]
        dangers <- map["dangers"]
        extensions <- map["extension"]
        grade <- map["grade"]
        taskId <- map["id"]
        level <- map["level"]
        calculation <- map["method_of_calculation"]
        name <- map["name"]
        remark <- map["remark"]
        response_person <- map["response_person"]
        response_unit <- map["response_unit"]
        risk_unit <- map["risk_unit"]
        standards <- map["standards"]
        status <- map["status"]
        updated <- map["updated"]
        accidents <- map["accidents"]
        classification <- map["classification"]
    }
    
    var code: String?
    var contact_phone: String?
    var created: String?
    var dangers: String?
    var extensions: String?
    var grade: String?
    var taskId: Int?
    var level: String?
    var calculation: String?
    var name: String?
    var remark: String?
    var response_person: String?
    var response_unit: String?
    var risk_unit: Int?
    var standards: String?
    var status: String?
    var updated: String?
    var accidents: [MLRiskAccidentModel]?
    var classification: [MLRiskClassificationModel]?
}

public class MLRiskAccidentModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["code"]
        description <- map["description"]
        accidentId <- map["id"]
        name <- map["name"]
    }
    
    var code: String?
    var description: String?
    var accidentId: Int?
    var name: String?
}

//MARK:
public class MLRiskClassificationModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
    }
    
    var code: String?
    var name: String?
}

//MARK: 用户每日的任务列表
public class MLDailyPlanDetailModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        expiration <- map["time_of_expiration"]
        time_of_finish <- map["time_of_finish"]
        time_of_start <- map["time_of_start"]
        enterprise <- map["enterprise"]
        risk_unit <- map["risk_unit"]
        created <- map["created"]
        updated <- map["updated"]
        status <- map["status"]
        planId <- map["id"]
    }
    
    var enterprise: Int?
    var planId: Int?
    var created: String?
    var risk_unit: MLRiskUnitDetailModel?
    var status: String?
    var updated: String?
    var expiration: String?
    var time_of_finish: String?
    var time_of_start: String?
}

//MARK: 用户需要检查的单元
public class MLRiskUnitDetailModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        cycle_type <- map["cycle_type"]
        enterprise <- map["enterprise"]
        unit_code <- map["unit_code"]
        unit_name <- map["unit_name"]
        category <- map["category"]
        updated <- map["updated"]
        status <- map["status"]
        cycle <- map["cycle"]
        risks <- map["risks"]
        unitId <- map["id"]
    }
    
    var category: MLRiskUnitCategoryModel?
    var cycle: Int?
    var cycle_type: String?
    var enterprise: Int?
    var unitId: Int?
    var risks: [MLRiskTaskDetailModel]?
    var status: String?
    var unit_code: String?
    var unit_name: String?
    var updated: String?
}
