//
//  MLCheckTaskHistoryModel.swift
//  MolueMediator
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueJames. All rights reserved.
//

import Foundation
import ObjectMapper

public class MLCheckTaskHistory: Mappable {
    public required init?(map: Map) {
        tasks <- map["tasks"]
        date <- map["date"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var tasks: [MLDailyCheckTask]?
    public var date: String?
}
