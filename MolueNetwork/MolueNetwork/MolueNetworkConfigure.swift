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
    public static var baseURL: String  {
        switch AppSchemeStatus.base() {
        case .debug:
            return "http://www.safety-saas.com"
        case .release:
            return "https://api.fushuninsurance.com/insurance-guide"
        }
    }
}

public protocol MolueActivityDelegate: NSObjectProtocol {
    func networkActivityStarted()
    func networkActivitySuccess()
    func networkActivityFailure(error: Error)
}
