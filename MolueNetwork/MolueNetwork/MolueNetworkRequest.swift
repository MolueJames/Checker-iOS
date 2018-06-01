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

public struct MolueDataRequest {
    var parameter: [String: Any]?
    var method: HTTPMethod
    var encoding: ParameterEncoding = URLEncoding.default
    var components: URLComponents?
    var headers: HTTPHeaders?

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
}

public extension SessionManager {
    public func doRequest(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil, delegate: MolueActivityDelegate? = nil)-> DataRequest {
        delegate?.networkActivityStarted()
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}

