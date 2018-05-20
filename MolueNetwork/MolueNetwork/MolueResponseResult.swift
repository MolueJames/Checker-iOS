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

public typealias responseClosure<Target:Mappable> = (ResponseEnum<Target>) -> Void

fileprivate enum HandleResponseError: Error {
    case responseTargetError
    case responseMapperError
}

public enum ResponseEnum <Target: Mappable>{
    case dictResult(response: Target)
    case listResult(response: [Target])
    case infoResult(response: String)
    case errorResult(response: Error)
    
    static func handleNetworkResponse(result: Result<Moya.Response, MoyaError>) -> ResponseEnum {
        switch result {
        case let .success(response):
            return handleSuccessResponse(response: response)
        case let .failure(error):
            return ResponseEnum.errorResult(response: error)
        }
    }

    private static func handleSuccessResponse(response: Moya.Response) -> ResponseEnum  {
        do {
            let responseJson = try response.mapJSON()
            return handleJsonResponse(responseJson: responseJson)
        } catch {
            return ResponseEnum.errorResult(response: error)
        }
    }
    
    private static func handleJsonResponse(responseJson: Any) -> ResponseEnum {
        if let response = responseJson as? [String: Any] {
            return handleDictResponse(response)
        } else if let response = responseJson as? [[String: Any]] {
            return handleListResponse(response)
        } else if let string = responseJson as? String {
            return ResponseEnum.infoResult(response: string)
        }
        return ResponseEnum.errorResult(response: HandleResponseError.responseTargetError)
    }
    
    private static func handleDictResponse(_ responseJson: [String: Any]) -> ResponseEnum {
        guard let object = Mapper<Target>().map(JSONObject: responseJson) else {
            return ResponseEnum.errorResult(response: HandleResponseError.responseMapperError)
        }
        return ResponseEnum.dictResult(response: object)
    }
    
    private static func handleListResponse(_ response: [[String: Any]]) -> ResponseEnum {
        let list = Mapper<Target>().mapArray(JSONArray: response)
        return ResponseEnum.listResult(response: list)
    }
}

public extension MoyaProvider {
    @discardableResult
    public func doRequest<T: Mappable>(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, response: @escaping responseClosure<T>) -> Cancellable {
        return self.request(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
            response(ResponseEnum<T>.handleNetworkResponse(result: result))
        })
    }
}

protocol MolueServiceProtocol {
    func start<T:Mappable>(_ provider: MoyaProvider<MolueNetworkProvider>, result: @escaping responseClosure<T>)
    func providerModel() -> MolueProviderModel
}

extension MolueServiceProtocol {
    func start<T>(_ provider: MoyaProvider<MolueNetworkProvider> = MoyaProvider<MolueNetworkProvider>(), result: @escaping responseClosure<T>) where T : Mappable {
        let target = MolueNetworkProvider(self.providerModel())
        provider.doRequest(target, response: result)
    }
}
