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

public typealias MolueResultClosure<Target> = (Target) -> Void

open class MolueRequestManager {
    private weak var delegate: MolueActivityDelegate?
    private var dataRequest: DataRequest?
    private var queue: DispatchQueue
    private var options: JSONSerialization.ReadingOptions
    private var request: MolueDataRequest
    private var failure: MolueResultClosure<Error>?
    private var success: MolueResultClosure<Any?>?
    
    public init(request: MolueDataRequest, delegate: MolueActivityDelegate? = nil, queue: DispatchQueue! = DispatchQueue.main, options: JSONSerialization.ReadingOptions! = .allowFragments) {
        self.queue = queue
        self.options = options
        self.request = request
        self.delegate = delegate
    }
    
    public func start() {
        guard let component = request.components, let url = try? component.asURL() else { fatalError("request url is invalid") }
        self.dataRequest = SessionManager.default.doRequest(url, method: request.method, parameters: request.parameter, encoding: request.encoding, headers: request.headers, delegate: delegate)
        self.dataRequest?.responseHandler(delegate: delegate, queue: queue, options: options, success: success, failure: failure)
    }
    @discardableResult
    public func handleAuthenticate(usingCredential: URLCredential) -> MolueRequestManager {
        self.dataRequest = self.dataRequest?.authenticate(usingCredential: usingCredential)
        return self
    }
    @discardableResult
    public func handleSuccessResponse(_ success: MolueResultClosure<Any?>?) -> MolueRequestManager {
        self.success = success
        return self
    }
    @discardableResult
    public func handleFailureResponse(_ failure: MolueResultClosure<Error>?) -> MolueRequestManager {
        self.failure = failure
        return self
    }
}

public struct MolueDataRequest {
    var parameter: [String: Any]?
    var method: HTTPMethod
    var encoding: ParameterEncoding = URLEncoding.default
    var components: URLComponents?
    var headers: HTTPHeaders?

    public init(baseURL: String! = HTTPConfigure.baseURL, parameter: [String: Any]?, method: HTTPMethod, path: String, headers: HTTPHeaders? = HTTPConfigure.header) {
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        let requestURL = baseURL + urlPath
        self.components = URLComponents(string: requestURL)
        self.parameter = parameter
        self.method = method
        self.encoding = requestEncoding(method: method)
        self.headers = headers
    }
    
    func requestEncoding(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

public extension SessionManager {
    public func doRequest(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding, headers: HTTPHeaders? = nil, delegate: MolueActivityDelegate? = nil)-> DataRequest {
        delegate?.networkActivityStarted()
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}

