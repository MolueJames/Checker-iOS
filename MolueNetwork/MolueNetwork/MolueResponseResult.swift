//
//  MolueResponseResult.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Moya
import Result

public typealias ResultClosure<ResultType> = (ResultType) -> Void

public protocol ResultResponseProtocol {
    
    associatedtype resultType
    
    var successClosure: ResultClosure<resultType>? {get set}
    var errorClosure: ResultClosure<Error>? {get set}
    
    func defaultHanldeResult(result: Result<Moya.Response, MoyaError>)
}

extension ResultResponseProtocol {
    
    public func defaultHanldeResult(result: Result<Moya.Response, MoyaError>)  {
        if case let .success(response) = result {
            let json = try? response.mapJSON()
            if let result = json as? resultType {
                if let closure = successClosure {
                    closure(result)
                } else {
                    fatalError("the succssClosure should not be nil")
                }
            } else {
                fatalError("the result value is not result Type")
            }
        }
        if case let .failure(error) = result{
            if let closure = errorClosure {
                closure(error)
            } else {
                fatalError("the errorClosure should not be nil")
            }
        }
    }
}

public class DefaultResponseResult<SuccessResult>:ResultResponseProtocol  {
    
    public typealias resultType = SuccessResult
    
    public var successClosure: ResultClosure<resultType>?
    
    public var errorClosure: ResultClosure<Error>?
    
    public init(success: @escaping ResultClosure<SuccessResult>, error: @escaping ResultClosure<Error>) {
        self.successClosure = success
        self.errorClosure = error
    }
}

public extension MoyaProvider {
    @discardableResult
    public func request<T:ResultResponseProtocol>(_ target: Target,
                                                  callbackQueue: DispatchQueue? = .none,
                                                  progress: ProgressBlock? = .none,
                                                  responseResult: T) -> Cancellable {
        return self.request(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
            responseResult.defaultHanldeResult(result: result)
        })
    }
}
