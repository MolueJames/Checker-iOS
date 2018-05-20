//
//  MolueResponseResult.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Moya
import Result
import ObjectMapper
import MolueUtilities

public typealias responseClosure<Target:Mappable> = (ResultEnum<Target>) -> Void

fileprivate enum HandleResponseError: Error {
    case responseTargetError
    case responseMapperError
}

public enum ResultEnum <Target: Mappable>{
    case dictResult(response: Target)
    case listResult(response: [Target])
    case infoResult(response: String)
    case errorResult(response: Error)
    
    static func handleNetworkResponse(result: Result<Moya.Response, MoyaError>) -> ResultEnum {
        switch result {
        case let .success(response):
            return handleSuccessResponse(response: response)
        case let .failure(error):
            return ResultEnum.errorResult(response: error)
        }
    }

    private static func handleSuccessResponse(response: Moya.Response) -> ResultEnum  {
        do {
            let responseJson = try response.mapJSON()
            return handleJsonResponse(responseJson: responseJson)
        } catch {
            return ResultEnum.errorResult(response: error)
        }
    }
    
    private static func handleJsonResponse(responseJson: Any) -> ResultEnum {
        if let response = responseJson as? [String: Any] {
            return handleDictResponse(response)
        } else if let response = responseJson as? [[String: Any]] {
            return handleListResponse(response)
        } else if let string = responseJson as? String {
            return ResultEnum.infoResult(response: string)
        }
        return ResultEnum.errorResult(response: HandleResponseError.responseTargetError)
    }
    
    private static func handleDictResponse(_ responseJson: [String: Any]) -> ResultEnum {
        guard let object = Mapper<Target>().map(JSONObject: responseJson) else {
            return ResultEnum.errorResult(response: HandleResponseError.responseMapperError)
        }
        return ResultEnum.dictResult(response: object)
    }
    
    private static func handleListResponse(_ response: [[String: Any]]) -> ResultEnum {
        let list = Mapper<Target>().mapArray(JSONArray: response)
        return ResultEnum.listResult(response: list)
    }
}

extension MoyaProvider {
    @discardableResult
    public func doRequest<T: Mappable>(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, response: @escaping responseClosure<T>) -> Cancellable {
        return self.request(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
            response(ResultEnum<T>.handleNetworkResponse(result: result))
        })
    }
}

public extension MolueProviderModel {
    
//     networkPlugin: [PluginType]? = nil
}
