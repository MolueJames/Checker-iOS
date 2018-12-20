//
//  MolueCheckService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

public struct MolueCheckService {
    public static func queryDailyPlanList(page: Int, pagesize: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": pagesize]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/risk/task/today/")
    }
    
    public static func queryDailyCheckTask(with taskId: String) -> MolueDataRequest {
        let path: String = "/api/task/\(taskId)/"
        return MolueDataRequest(parameter: nil, method: .get, path: path)
    }
}
