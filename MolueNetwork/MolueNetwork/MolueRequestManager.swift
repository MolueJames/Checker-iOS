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
    
    public func doRequestStart(with request: MolueDataRequest, needOauth: Bool = true) {
        func checkNeedQueryToken(with needOauth: Bool) -> Bool {
            guard needOauth == true else { return needOauth }
            do {
                let item = try MolueOauthModel.queryOauthItem().unwrap()
                return needOauth && item.validateNeedRefresh()
            } catch { return needOauth }
        }
        
        if (checkNeedQueryToken(with: needOauth)) {
            self.queryTokenFromServer(with: request)
        } else {
            self.queryDataFromServer(with: request)
        }
    }
    
    func queryTokenFromServer(with request: MolueDataRequest) {
        let requestItem: MolueRequestItem = (request: request, manager: self)
        MolueOauthRequestManager.shared.insert(with: requestItem)
        MolueOauthRequestManager.shared.startRefreshTokenRequest()
    }
    
    func queryDataFromServer(with request: MolueDataRequest) {
        self.doGenerateDataRequestTask(with: request).continueOnSuccessWith { result in
            self.handleSuccessResult(with: result, request: request)
        }.continueOnErrorWith { (error) in
            self.handleFailureResult(with: error, request: request)
        }
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
    
    func doGenerateDataRequestTask(with request: MolueDataRequest) -> Task<Any?> {
        let taskCompletionSource = TaskCompletionSource<Any?>()
        do {
            let dataRequest = try self.createDataRequest(with: request).unwrap()
            dataRequest.responseHandler(delegate: delegate, options: options, queue: self.requestQueue, success: { (result) in
                taskCompletionSource.set(result: result)
            }) { (error) in
                taskCompletionSource.set(error: error)
            }
        } catch { MolueLogger.failure.message(error) }
        return taskCompletionSource.task
    }
    
    private func createDataRequest(with request: MolueDataRequest) -> DataRequest? {
        do {
            let requestURL = try request.components.unwrap().asURL()
            return SessionManager.default.doRequest(requestURL, method: request.method, parameters: request.parameter, encoding: request.encoding, headers: request.headers, delegate: delegate, requestQueue: self.requestQueue)
        } catch { return MolueLogger.network.returnNil(error) }
    }
    
}

private let single = MolueOauthRequestManager()

fileprivate class MolueOauthRequestManager: MolueRequestManager {
    private let insertLock = NSLock()
    var isRefreshing: Bool = false
    var requestItems = [MolueRequestItem]()
    
    fileprivate static var shared: MolueOauthRequestManager {
        return single
    }
    
    fileprivate func insert(with request: MolueRequestItem) {
        insertLock.lock(); defer {insertLock.unlock()}
        requestItems.append(request)
    }
    
    private func dofinishRequestOperation() {
        insertLock.lock(); defer {insertLock.unlock()}
        self.requestItems.removeAll()
        self.isRefreshing = false
    }
    
    public func startRefreshTokenRequest() {
        guard self.validateOauthRequest() == true else {return}
        let refreshToken = MolueOauthHelper.queryRefreshToken()
        let request = MolueOauthService.doRefreshToken(with: refreshToken)
        self.doRefreshTokenRequest(with: request)
    }
    
    private func doRefreshTokenRequest(with request: MolueDataRequest) {
        self.doGenerateDataRequestTask(with: request).continueOnSuccessWith { result in
            self.saveOauthItemToKeyChain(with: result)
            self.doOperationWithOauthSuccess(with: self.requestItems)
        }.continueOnErrorWith { (error) in
            self.doOpertionsWhenOauthFailure(with: self.requestItems, error: error)
        }
    }
    
    private func saveOauthItemToKeyChain(with result: Any?) {
        do {
            let item = Mapper<MolueOauthModel>().map(JSONObject: result)
            try MolueOauthModel.updateOauthItem(with: item.unwrap())
        } catch { MolueLogger.network.message(error) }
    }
}

extension MolueOauthRequestManager {
    
    private func doOperationWithOauthSuccess(with list: [MolueRequestItem]) {
        func doRequestItemSuccess(with manager: MolueRequestManager) {
            do {
                let delegate = try manager.delegate.unwrap()
                delegate.networkActivitySuccess()
            } catch { MolueLogger.network.message(error)}
        }
        
        defer {self.dofinishRequestOperation()}
        list.forEach { (request: MolueDataRequest, manager: MolueRequestManager) in
            doRequestItemSuccess(with: manager)
            request.headers = MolueOauthHelper.queryUserOauthHeaders()
            manager.queryDataFromServer(with: request)
        }
    }
    
    private func doOpertionsWhenOauthFailure(with list: [MolueRequestItem], error: Error) {
        func doRequestItemFailure(with manager: MolueRequestManager, error: Error) {
            do {
                let delegate = try manager.delegate.unwrap()
                delegate.networkActivityFailure(error: error)
            } catch { MolueLogger.network.message(error)}
        }
        
        defer {self.dofinishRequestOperation()}
        list.forEach { (request: MolueDataRequest, manager: MolueRequestManager) in
            doRequestItemFailure(with: manager, error: error)
            manager.handleFailureResult(with: error, request: request)
        }
    }
    
    private func validateOauthRequest() -> Bool {
        insertLock.lock(); defer {insertLock.unlock()}
        defer {self.isRefreshing = true}
        guard self.isRefreshing == false else { return false }
        self.requestItemsStarted(with: self.requestItems)
        return true
    }
    
    private func requestItemsStarted(with list: [MolueRequestItem]) {
        func doRequestItemStarted(with manager: MolueRequestManager) {
            do {
                let delegate = try manager.delegate.unwrap()
                delegate.networkActivityStarted()
            } catch { MolueLogger.network.message(error)}
        }
        
        list.forEach { (request: MolueDataRequest, manager: MolueRequestManager) in
            doRequestItemStarted(with: manager)
        }
    }
}
