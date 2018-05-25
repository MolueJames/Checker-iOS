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
    
    public func responseHandler(delegate observer: MolueActivityDelegate?, queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, success:MolueResultClosure<Any?>? = nil, failure: MolueResultClosure<Error>? = nil) {
        let operation = BlockOperation.init { [weak observer]  in
            if self.handleDefaultError(self.delegate.error, delegate: observer, failure: failure) {return}
            let status = self.validateResponse(self.response)
            let serviceResult = self.handleResponseStatus(status, options: options)
            self.handleServiceResult(serviceResult, delegate: observer, success: success, failure: failure)
            self.startRequestInfoLogger()
        }
        delegate.queue.addOperation(operation)
    }
    
    private func handleDefaultError(_ error: Error?, delegate: MolueActivityDelegate?, failure: MolueResultClosure<Error>? = nil) -> Bool {
        guard let error = error else {return false}
        delegate?.networkActivityFailure(error: error)
        failure?(error)
        return true
    }
    
    private func startRequestInfoLogger () {
        MolueLogger.network.message(self.request)
        MolueLogger.network.message(self.response)
    }
    
    private func handleServiceResult(_ result: MolueServiceResponse, delegate: MolueActivityDelegate?, success:MolueResultClosure<Any?>? = nil, failure: MolueResultClosure<Error>? = nil) {
        switch result {
        case .resultSuccess(let result):
            success?(result)
            delegate?.networkActivitySuccess()
        case .resultFailure(let result):
            failure?(result)
            delegate?.networkActivityFailure(error: result)
        }
    }
    
    private func handleResponseStatus(_ status: MolueResponseStatus, options: JSONSerialization.ReadingOptions) -> MolueServiceResponse {
        switch status {
        case .reponseSuccess(let data):
            let result = self.transferJsonWithResponseData(data, options: options)
            return MolueServiceResponse.resultSuccess(result: result)
        case .authenticateFailure(let description):
            let name = NSNotification.Name(rawValue: "com.authorization.timeout.molue")
            NotificationCenter.default.post(name: name, object: nil)
            let error = MolueStatusError.authenticateFailure(description: description)
            return MolueServiceResponse.resultFailure(result: error)
        case .requestIsNotExisted(let description):
            let error = MolueStatusError.requestIsNotExisted(description: description)
            return MolueServiceResponse.resultFailure(result: error)
        case .bussinessError(let data):
            let result = self.transferJsonWithResponseData(data, options: options)
            let error = MolueStatusError.bussinessError(result: result)
            return MolueServiceResponse.resultFailure(result: error)
        }
    }
    
    private func transferJsonWithResponseData(_ data: Data?, options: JSONSerialization.ReadingOptions) -> Any? {
        guard let data = data else {return nil}
        return try? JSONSerialization.jsonObject(with: data, options: options)
    }
    
    private func validateResponse(_ response: HTTPURLResponse?) -> MolueResponseStatus {
        switch response?.statusCode {
        case 200:
            return MolueResponseStatus.reponseSuccess(data: self.delegate.data)
        case 401:
            let description = "授权超时,请重新登录"
            return MolueResponseStatus.authenticateFailure(description: description)
        case 404:
            let description = "您访问的页面已消失!"
            return MolueResponseStatus.requestIsNotExisted(description: description)
        default:
            return MolueResponseStatus.bussinessError(data: self.delegate.data)
        }
    }
}

private enum MolueResponseStatus {
    case authenticateFailure(description: String)
    case requestIsNotExisted(description: String)
    case bussinessError(data: Data?)
    case reponseSuccess(data: Data?)
}

private enum MolueServiceResponse {
    case resultSuccess(result: Any?)
    case resultFailure(result: Error)
}

private enum MolueStatusError: LocalizedError {
    case authenticateFailure(description: String)
    case requestIsNotExisted(description: String)
    case bussinessError(result: Any?)
    
    var errorDescription: String? {
        switch self {
        case .authenticateFailure(let description):
            return description
        case .requestIsNotExisted(let description):
            return description
        case .bussinessError(let result):
            return handleErrorResult(result: result)
        }
    }
    
    func handleErrorResult(result: Any?) -> String {
        guard let result = result, let response = result as? [String: Any] else {return "服务器发生了未知错误"}
        guard let code = response["code"], let message = response["message"] else {return "服务器发生了未知错误"}
        return "错误ID:" + String(describing: code) + "\n错误信息:" + String(describing: message)
    }
}
