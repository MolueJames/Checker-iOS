//
//  MolueUserProvider.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Moya
class AppVersion: TargetType {
    private let device:String
    private let version:String
    
    
    public init(device:String, version:String) {
        self.device = device
        self.version = version
    }
    
    public var baseURL: URL {
        return URL(string: HTTPConfigure().baseURL)!
    }
    
    public var path: String {
        return "api/app/version"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        let sampleString = """
        {"code":"1","data":null}
        """
        return sampleString.data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        return .requestParameters(parameters:["version":self.version, "device":self.device], encoding:URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        return HTTPConfigure().header
    }
}
