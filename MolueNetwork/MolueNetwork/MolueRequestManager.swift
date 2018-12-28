//
//  MolueRequestManager.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Alamofire
import BoltsSwift
import ObjectMapper
import MolueUtilities
import MolueMediator

public typealias MolueRequestItem = (request: MolueDataRequest, manager: MolueRequestManager)
public typealias MolueResultClosure<Target> = (Target) -> Void

open class MolueRequestManager {
    private(set) weak var delegate: MolueActivityDelegate?
    private(set) var requestQueue: DispatchQueue
    private var options: JSONSerialization.ReadingOptions
    
    public init(delegate: MolueActivityDelegate? = nil, queue: DispatchQueue! = DispatchQueue.main, options: JSONSerialization.ReadingOptions! = .allowFragments) {
        self.requestQueue = queue
        self.options = options
        self.delegate = delegate
    }
    
    @discardableResult
    public func doRequestStart(with request: MolueDataRequest, needOauth: Bool = true) -> Task<Any?> {
        if (MolueOauthHelper.checkNeedQueryToken(with: needOauth)) {
            return self.queryTokenFromServer(with: request)
        } else {
            return self.queryDataFromServer(with: request)
        }
    }
    
    @discardableResult
    func queryTokenFromServer(with request: MolueDataRequest) -> Task<Any?> {
        let requestItem: MolueRequestItem = (request: request, manager: self)
        MolueOauthRequestManager.shared.insert(with: requestItem)
        return MolueOauthRequestManager.shared.startRefreshTokenRequest()
    }
    
    func handleSuccessResult(with result: Any?, request: MolueDataRequest?) {
        do {
            let request = try request.unwrap()
            try request.success.unwrap()(result)
        } catch { MolueLogger.network.message(error) }
    }
    
    func handleFailureResult(with result: Error, request: MolueDataRequest?) {
        do {
            let request = try request.unwrap()
            try request.failure.unwrap()(result)
        } catch { MolueLogger.network.message(error) }
    }
    
    @discardableResult
    func queryDataFromServer(with request: MolueDataRequest) -> Task<Any?> {
        let taskCompletionSource = TaskCompletionSource<Any?>()
        let dataRequest = self.createDataRequest(with: request)
        dataRequest.responseHandler(delegate: delegate, options: options, queue: requestQueue, success: { (result) in
            self.handleSuccessResult(with: result, request: request)
            taskCompletionSource.set(result: result)
        }) { (error) in
            self.handleFailureResult(with: error, request: request)
            taskCompletionSource.set(error: error)
        }
        return taskCompletionSource.task
    }
    
    private func createDataRequest(with request: MolueDataRequest) -> DataRequest {
        do {
            let requestURL = try request.components.unwrap().asURL()
            return SessionManager.default.doRequest(requestURL, method: request.method, parameters: request.parameter, encoding: request.encoding, headers: request.headers, delegate: delegate, requestQueue: requestQueue)
        } catch { fatalError(error.localizedDescription) }
    }
}

private let single = MolueOauthRequestManager()

fileprivate class MolueOauthRequestManager: MolueRequestManager {
    var requestItems = [MolueRequestItem]()
    var currentTask: Task<Any?>?
    
    fileprivate static var shared: MolueOauthRequestManager {
        return single
    }
    
    fileprivate func insert(with request: MolueRequestItem) {
        objc_sync_enter(self); defer {objc_sync_exit(self)}
        requestItems.append(request)
    }
    
    private func dofinishRequestOperation() {
        objc_sync_enter(self); defer {objc_sync_exit(self)}
        self.requestItems.removeAll()
        self.currentTask = nil
    }

    public func startRefreshTokenRequest() -> Task<Any?> {
        if let currentTask = self.currentTask {
            return currentTask
        }
        let refreshToken:String? = MolueOauthHelper.queryRefreshToken()
        let request = MolueOauthService.doRefreshToken(with: refreshToken)
        self.currentTask = self.doRefreshTokenRequest(with: request)
        return self.currentTask!
    }
    
    @discardableResult
    private func doRefreshTokenRequest(with request: MolueDataRequest) -> Task<Any?> {
        let taskCompletionSource = TaskCompletionSource<Any?>()
        self.queryDataFromServer(with: request).continueOnSuccessWith { result in
            self.doOperationWithOauthSuccess(with: self.requestItems, result: result)
            taskCompletionSource.set(result: result)
        }.continueOnErrorWith(continuation: { error in
            self.doOpertionsWhenOauthFailure(with: self.requestItems, error: error)
            taskCompletionSource.set(error: error)
        })
        return taskCompletionSource.task
    }
    
}

extension MolueOauthRequestManager {

    private func saveOauthItemToKeyChain(with result: Any?) {
        do {
            let item = Mapper<MolueOauthModel>().map(JSONObject: result)
            try MolueOauthModel.updateOauthItem(with: item.unwrap())
        } catch { MolueLogger.network.message(error) }
    }
    
    private func doOperationWithOauthSuccess(with list: [MolueRequestItem], result: Any?) {
        self.saveOauthItemToKeyChain(with: result)
        list.forEach { (request: MolueDataRequest, manager: MolueRequestManager) in
            request.headers = MolueOauthHelper.queryUserOauthHeaders()
            manager.queryDataFromServer(with: request)
        }
        self.dofinishRequestOperation()
    }
    
    private func doOpertionsWhenOauthFailure(with list: [MolueRequestItem], error: Error)  {
        list.forEach { (request: MolueDataRequest, manager: MolueRequestManager) in
            manager.handleFailureResult(with: error, request: request)
        }
        self.dofinishRequestOperation()
    }
}
