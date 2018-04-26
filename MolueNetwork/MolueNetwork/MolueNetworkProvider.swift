//
//  MolueNetworkProvider.swift
//  MolueNetwork
//
//  Created by James on 2018/4/25.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Moya
public typealias Method = Moya.Method
public struct MolueProviderModel {
    fileprivate let baseURL: String
    fileprivate let path: String
    fileprivate let method: Method
    fileprivate let header: [String: String]?
    fileprivate let task: Task
    fileprivate let sampleData: Data
    
    init(_ baseURL: String? = HTTPConfigure().baseURL, path: String, method: Method, header: [String: String]? = nil, task: Task, sampleData: Data? = "sample data".data(using: String.Encoding.utf8)!) {
        self.baseURL = baseURL!
        self.path = path
        self.method = method
        self.header = header
        self.task = task
        self.sampleData = sampleData!
    }
}

public enum MolueProvideTask {
    case URLEncode(parameters: [String : Any])
    case JsonEncode(parameters: [String : Any])
    case NoParameters
    
    func toTask() -> Task {
        switch self {
        case .URLEncode(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .JsonEncode(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .NoParameters:
            return .requestPlain
        }
    }
}

public class MolueNetworkProvider: TargetType {
    private let model: MolueProviderModel
    
    public init(_ model: MolueProviderModel) {
        self.model = model
    }
    
    public var baseURL: URL {
        return URL(string: self.model.baseURL)!
    }
    
    public var path: String {
        return self.model.path
    }
    
    public var method: Moya.Method {
        return self.model.method
    }
    
    public var sampleData: Data {
        return self.model.sampleData
    }
    
    public var task: Task {
        return self.model.task
    }
    
    public var headers: [String : String]? {
        return self.model.header
    }
}
