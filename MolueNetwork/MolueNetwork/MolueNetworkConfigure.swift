//
//  MolueNetworkConfigure.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
public enum AppSchemeStatus {
    case debug
    case release
    public static func base() -> AppSchemeStatus {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
}

public struct HTTPConfigure {
    var baseURL: String  {
        switch AppSchemeStatus.base() {
        case .debug:
            return "https://api.fushuninsurance.com/insurance-guide"
        case .release:
            return "https://api.fushuninsurance.com/insurance-guide"
        }
    }
    
    var header: Dictionary<String, String> {
        switch AppSchemeStatus.base() {
        case .debug:
            return ["ver":"1.1.0","Content-Type":"application/json"]
        case .release:
            return ["ver":"1.1.0","Content-Type":"application/json"]
        }
    }
}
