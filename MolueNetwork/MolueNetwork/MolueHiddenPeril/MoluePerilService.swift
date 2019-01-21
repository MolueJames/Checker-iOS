//
//  MoluePerilService.swift
//  MolueNetwork
//
//  Created by MolueJames on 2019/1/9.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import Foundation
import Alamofire

public struct MoluePerilService {
    public static func queryHiddenPerils(with status: String, page: Int, size: Int) -> MolueDataRequest {
        let parameters: [String : Any] = ["page": page, "page_size": size, "status" : status]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/hidden_dangers/")
    }
    
    public static func uploadHiddenPeril(with parameters: [String : Any]) -> MolueDataRequest {
        let path: String = "api/hidden_dangers/"
        return MolueDataRequest(parameter: parameters, method: .post, path: path, encoding: JSONEncoding.default)
    }
    
    public static func uploadHiddenPeril(with parameters: [String : Any], taskId: String) -> MolueDataRequest {
        let path: String = "api/task/\(taskId)/hidden_dangers/"
        return MolueDataRequest(parameter: parameters, method: .post, path: path, encoding: JSONEncoding.default)
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
    
    public static func queryHiddenPeril(with taskId: String) -> MolueDataRequest {
        let path: String = "api/task/\(taskId)/hidden_dangers/"
        return MolueDataRequest(parameter: nil, method: .get, path: path)
    }
    ///  上传整改步骤计划
    ///
    /// - Parameters:
    ///   - parameters: 隐患步骤, 是否限时, 限定整改时间
    ///   - perilId: 隐患的Id
    /// - Returns: 网络请求对象
    public static func uploadRectifySteps(with parameters: [String : Any], perilId: String) -> MolueDataRequest {
        let path: String = "api/hidden_dangers/\(perilId)/approved/"
        return MolueDataRequest(parameter: parameters, method: .post, path: path, encoding: JSONEncoding.default)
    }
}
