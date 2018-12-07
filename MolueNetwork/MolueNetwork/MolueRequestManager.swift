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
import MolueUtilities

public typealias MolueRequestItem = (request: MolueDataRequest, manager: MolueRequestManager)
public typealias MolueResultClosure<Target> = (Target) -> Void

private let userKey = "hj8LAJukEhrs37yPbvXlwX5kG8sk45q0gciIw1Ol"
private let password = "jEOk3ZLDixlJWPyyoncEbcwp4z3Ij5VG05HfKGORg5357CCWeRnrY86OPFpCPF79FaRiUGHnUcb68uCp5NScHg3z5roBqkVY3eB2LHrEaByULCY4JFMRDvXTa7a3ITq9"

open class MolueRequestManager {
    private(set) weak var delegate: MolueActivityDelegate?
    private var dataRequest: DataRequest?
    private var requestQueue: DispatchQueue
    private var options: JSONSerialization.ReadingOptions
    
    public init(delegate: MolueActivityDelegate? = nil, queue: DispatchQueue! = DispatchQueue.main, options: JSONSerialization.ReadingOptions! = .allowFragments) {
        self.requestQueue = queue
        self.options = options
        self.delegate = delegate
    }
    
    public func doRequestStart(with request: MolueDataRequest, needOauth: Bool = true) {
        if (needOauth) {
            self.queryTokenFromServer(with: request)
        } else {
            self.queryDataFromServer(with: request)
        }
    }
    
    func queryTokenFromServer(with request: MolueDataRequest) {
        let requestItem: MolueRequestItem = (request: request, manager: self)
        MolueOauthRequestManager.shared.insert(with: requestItem)
        MolueOauthRequestManager.shared.startOauthRequest()
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
    
    public func doGenerateDataRequestTask(with request: MolueDataRequest) -> Task<Any?> {
        let taskCompletionSource = TaskCompletionSource<Any?>()
        do {
            let requestURL = try request.components.unwrap().asURL()
            self.dataRequest = SessionManager.default.doRequest(requestURL, method: request.method, parameters: request.parameter, encoding: request.encoding, headers: request.headers, delegate: delegate)
            let dataRequest = try self.dataRequest.unwrap()
            dataRequest.responseHandler(delegate: delegate, queue: requestQueue, options: options, success: { (result) in
                taskCompletionSource.set(result: result)
            }) { (error) in
                taskCompletionSource.set(error: error)
            }
        } catch {
            MolueLogger.failure.message(error)
        }
        return taskCompletionSource.task
    }
}

private let single = MolueOauthRequestManager()
public class MolueOauthRequestManager: MolueRequestManager {
    private let insertLock = NSLock()
    var isRefreshing: Bool = false
    var requestItems = [MolueRequestItem]()
    
    public static var shared: MolueOauthRequestManager {
        return single
    }
    
    public func insert(with request: MolueRequestItem) {
        insertLock.lock(); defer {insertLock.unlock()}
        requestItems.append(request)
    }
    
    private func dofinishRequestOperation() {
        insertLock.lock(); defer {insertLock.unlock()}
        self.requestItems.removeAll()
        self.isRefreshing = false
    }
    
    public func startOauthRequest() {
        if self.validateOauthRequest() == false {return}
        let parameters = ["username":"13063745829", "password":"q1w2e3r4","grant_type":"password"]
        let headers = self.queryOauthRequestHeaders()
        let request = MolueDataRequest(parameter: parameters, method: .post, path: "oauth/token/", headers: headers)
        self.doGenerateDataRequestTask(with: request).continueOnSuccessWith { result in
            self.doOperationWithOauthSuccess(with: self.requestItems)
        }.continueOnErrorWith { (error) in
            self.doOpertionsWhenOauthFailure(with: self.requestItems, error: error)
        }
    }

    private func queryOauthRequestHeaders() -> HTTPHeaders? {
        do {
            let header = Request.authorizationHeader(user: userKey, password: password)
            let oauthHeader = try header.unwrap()
            return [oauthHeader.key : oauthHeader.value]
        } catch { return nil}
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
