//
//  MolueNetworkRequest.swift
//  MolueNetwork
//
//  Created by James on 2018/5/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Alamofire
import MolueUtilities

public class MolueDataRequest {
    var parameter: [String: Any]?
    var method: HTTPMethod
    var encoding: ParameterEncoding = URLEncoding.default
    var components: URLComponents?
    var headers: HTTPHeaders?
    private(set) var failure: MolueResultClosure<Error>?
    private(set) var success: MolueResultClosure<Any?>?
    
    public init(baseURL: String! = HTTPConfigure.baseURL, parameter: [String: Any]?, method: HTTPMethod, path: String, headers: HTTPHeaders? = nil, encoding:ParameterEncoding! = URLEncoding.default) {
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        let requestURL = baseURL + urlPath
        self.components = URLComponents(string: requestURL)
        self.components?.port = 50002
        self.parameter = parameter
        self.method = method
        self.encoding = encoding
        self.headers = headers
    }
    
    @discardableResult
    public func handleSuccessResponse(_ success: MolueResultClosure<Any?>?) -> MolueDataRequest {
        self.success = success
        return self
    }
    
    @discardableResult
    public func handleFailureResponse(_ failure: MolueResultClosure<Error>?) -> MolueDataRequest {
        self.failure = failure
        return self
    }
}

public extension SessionManager {
    public func doRequest(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil, delegate: MolueActivityDelegate? = nil)-> DataRequest {
        do {
            try delegate.unwrap().networkActivityStarted()
        } catch {
            MolueLogger.network.message(error)
        }
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}

