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
            let serviceResult = self.handleResponseStatus(self.response, options: options)
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
        let name = NSNotification.Name(rawValue: "com.authorization.timeout.molue")
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
        guard let data = data else {throw MolueStatusError.transferJsonFailure}
        do {
           return try JSONSerialization.jsonObject(with: data, options: options)
        } catch {
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
    case successResponseIsNil
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
        case .successResponseIsNil:
            return "服务器数据为空数据!"
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
