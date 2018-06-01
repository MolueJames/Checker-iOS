//
//  MolueRequestManager.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
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
        guard let component = request.components, let url = try? component.asURL() else {
            MolueLogger.failure.error("request url is invalid")
            return
        }
        self.dataRequest = SessionManager.default.doRequest(url, method: request.method, parameters: request.parameter, encoding: request.encoding, headers: request.headers, delegate: delegate)
        self.dataRequest?.responseHandler(delegate: delegate, queue: queue, options: options, success: success, failure: failure)
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
