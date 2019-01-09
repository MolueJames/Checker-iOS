//
//  MolueCheckService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import Alamofire

public struct MolueCheckService {
    public static func queryDailyPlanList(page: Int, size: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": size]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/risk/task/today/")
    }
    
    public static func queryDailyCheckTask(with taskId: String) -> MolueDataRequest {
        let path: String = "/api/task/\(taskId)/"
        return MolueDataRequest(parameter: nil, method: .get, path: path)
    }
    
    public static func updateDailyCheckTask(with taskId: String, paramaters: [String: Any]) -> MolueDataRequest {
        let path: String = "api/task/\(taskId)/"
        return MolueDataRequest(parameter: paramaters, method: .put, path: path, encoding: JSONEncoding.default)
    }
    
    public static func queryCheckTaskHistory(with startDate: String, endDate: String) -> MolueDataRequest {
        let parameter = ["start_date" : startDate, "end_date" : endDate]
        return MolueDataRequest(parameter: parameter, method: .get, path: "api/task/history/")
    }
    
    public static func queryDailyTaskHistory(with created: String) -> MolueDataRequest {
        return MolueDataRequest(parameter: ["created" : created], method: .get, path: "api/task/")
    }
}
