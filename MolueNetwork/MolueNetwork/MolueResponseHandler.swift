//
//  MolueResponseHandler.swift
//  MolueNetwork
//
//  Created by James on 2018/5/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Alamofire
import MolueUtilities

public extension DataRequest {
    
    public func responseHandler(delegate observer: MolueActivityDelegate?, options: JSONSerialization.ReadingOptions = .allowFragments, queue: DispatchQueue, success:MolueResultClosure<Any?>? = nil, failure: MolueResultClosure<Error>? = nil) {
        let operation = BlockOperation.init { [weak observer]  in
            self.doResponseHandler(delegate: observer, options: options, queue: queue, success: success, failure: failure)
        }
        self.delegate.queue.addOperation(operation)
    }
    public func doResponseHandler(delegate observer: MolueActivityDelegate?, options: JSONSerialization.ReadingOptions , queue: DispatchQueue, success:MolueResultClosure<Any?>?, failure: MolueResultClosure<Error>?) {
        queue.async {
            if self.handleDefaultError(self.delegate.error, delegate: observer, failure: failure, queue: queue) {return}
            let serviceResult = self.handleResponseStatus(self.response, options: options)
            self.handleServiceResult(serviceResult, delegate: observer, success: success, failure: failure, queue: queue)
            self.startRequestInfoLogger()
        }
    }
    
    
    private func handleDefaultError(_ error: Error?, delegate: MolueActivityDelegate?, failure: MolueResultClosure<Error>? = nil, queue: DispatchQueue) -> Bool {
        do {
            let error = try error.unwrap()
            try delegate.unwrap().networkActivityFailure(error: error)
            try failure.unwrap()(error)
            return true
        } catch {
            MolueLogger.failure.message(error)
            return false
        }
    }
    
    private func startRequestInfoLogger () {
        MolueLogger.network.message(self.request)
        MolueLogger.network.message(self.request?.allHTTPHeaderFields)
        MolueLogger.network.message(self.response?.statusCode)
    }
    
    private func handleServiceResult(_ result: MolueServiceResponse, delegate: MolueActivityDelegate?, success:MolueResultClosure<Any?>? = nil, failure: MolueResultClosure<Error>? = nil, queue: DispatchQueue) {
        do {
            switch result {
            case .resultSuccess(let result):
                try success.unwrap()(result)
                try delegate.unwrap().networkActivitySuccess()
            case .resultFailure(let result):
                try failure.unwrap()(result)
                try delegate.unwrap().networkActivityFailure(error: result)
            }
        } catch {
            MolueLogger.network.message(error)
        }
    }
    
    private func handleResponseStatus(_ response: HTTPURLResponse?, options: JSONSerialization.ReadingOptions) -> MolueServiceResponse {
        switch self.validateResponse(response) {
        case .reponseSuccess(let data):
            return self.reponseSuccessHandler(data, options: options)
        case .authenticateFailure:
            return self.authenticateFailureHandler()
        case .requestIsNotExisted:
            return self.requestIsNotExistedHandler()
        case .bussinessError(let data):
            return self.bussinessErrorHandler(data, options: options)
        }
    }
    
    private func requestIsNotExistedHandler() -> MolueServiceResponse {
        let error = MolueStatusError.requestIsNotExisted
        return MolueServiceResponse.resultFailure(result: error)
    }
    
    private func authenticateFailureHandler() -> MolueServiceResponse {
        let name = NSNotification.Name(rawValue: "molue_need_login")
        NotificationCenter.default.post(name: name, object: nil)
        let error = MolueStatusError.authenticateFailure
        return MolueServiceResponse.resultFailure(result: error)
    }
    
    private func bussinessErrorHandler(_ data: Data?, options: JSONSerialization.ReadingOptions) -> MolueServiceResponse {
        do {
            let result = try self.transferJsonWithResponseData(data, options: options)
            let error = MolueStatusError.bussinessError(result: result)
            return MolueServiceResponse.resultFailure(result: error)
        } catch {
            return MolueServiceResponse.resultFailure(result: error)
        }
    }
    
    private func reponseSuccessHandler(_ data: Data?, options: JSONSerialization.ReadingOptions) -> MolueServiceResponse {
        do {
            let result = try self.transferJsonWithResponseData(data, options: options)
            return MolueServiceResponse.resultSuccess(result: result)
        } catch {
            return MolueServiceResponse.resultFailure(result: error)
        }
    }
    
    private func transferJsonWithResponseData(_ data: Data?, options: JSONSerialization.ReadingOptions) throws -> Any {
        do {
            let data = try data.unwrap()
            return try JSONSerialization.jsonObject(with: data, options: options)
        } catch {
            MolueLogger.failure.message(error)
            throw MolueStatusError.transferJsonFailure
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse?) -> MolueResponseStatus {
        switch response?.statusCode {
        case 200:
            return MolueResponseStatus.reponseSuccess(data: self.delegate.data)
        case 401:
            return MolueResponseStatus.authenticateFailure
        case 404:
            return MolueResponseStatus.requestIsNotExisted
        default:
            return MolueResponseStatus.bussinessError(data: self.delegate.data)
        }
    }
}

private enum MolueResponseStatus {
    case authenticateFailure
    case requestIsNotExisted
    case bussinessError(data: Data?)
    case reponseSuccess(data: Data?)
}

private enum MolueServiceResponse {
    case resultSuccess(result: Any?)
    case resultFailure(result: Error)
}

public enum MolueStatusError: LocalizedError {
    
    case authenticateFailure
    case requestIsNotExisted
    case transferJsonFailure
    case mapperResponseError
    case bussinessError(result: Any?)
    
    public var errorDescription: String? {
        switch self {
        case .authenticateFailure:
            return "授权超时,请重新登录"
        case .requestIsNotExisted:
            return "您访问的页面不存在!"
        case .transferJsonFailure:
            return "服务器返回数据异常!"
        case .mapperResponseError:
            return "服务器数据映射出错!"
        case .bussinessError(let result):
            return handleErrorResult(result: result)
        }
    }
    
    func handleErrorResult(result: Any?) -> String {
        do {
            let response: [String: Any] = try validateTarget(result)
            let code = try response["code"].unwrap()
            let message = try response["message"].unwrap()
            return "错误ID:" + String(describing: code) + "\n错误信息:" + String(describing: message)
        } catch {
            MolueLogger.network.error(error)
            return "服务器发生了未知错误"
        }
    }
}
