//
//  MoluePerilService.swift
//  MolueNetwork
//
//  Created by MolueJames on 2019/1/9.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import Foundation

public struct MoluePerilService {
    public static func queryHiddenPerils(with status: String, page: Int, size: Int) -> MolueDataRequest {
        let parameters: [String : Any] = ["page": page, "page_size": size, "status" : status]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/hidden_dangers/")
    }
    
    public static func updateHiddenPeril(with parameters:[String : Any]) -> MolueDataRequest {
        let path: String = "api/hidden_dangers/"
        return MolueDataRequest(parameter: parameters, method: .put, path: path)
    }
    
    public static func queryPerilUnitPosition(page: Int, size: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": size]
        let path: String = "api/risk/risk_unit/"
        return MolueDataRequest(parameter: parameters, method: .get, path: path)
    }
    
    public static func queryRiskClassification(page: Int, size: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": size]
        let path: String = "api/classifications/"
        return MolueDataRequest(parameter: parameters, method: .get, path: path)
    }
}
