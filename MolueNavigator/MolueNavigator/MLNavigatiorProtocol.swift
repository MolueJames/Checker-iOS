
//
//  MLNavigatiorProtocol.swift
//  MolueNavigator
//
//  Created by MolueJames on 2018/6/27.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public protocol MolueNavigatorProtocol: NSObjectProtocol {
    /// transfer parameters
    ///
    /// - Parameter params: for business logic
    func doTransferParameters(params: Any?)
    /// transfer parameters
    ///
    /// - Parameter params: for user interface
    func doSettingParameters(params: String)
}

public protocol MLAppNavigatorProtocol {
    var router: MolueAppRouter {get}
    
    func push(_ viewController: UIViewController)
    
    func present(_ viewController: UIViewController)
}

public extension MLAppNavigatorProtocol {
    public var router: MolueAppRouter {
        return MolueAppRouter.shared
    }
    func push(_ viewController: UIViewController) {
        self.router.push(viewController)
    }
    func present(_ viewController: UIViewController) {
        self.router.present(viewController)
    }
}

public struct MLNavigatorTransfer {
    public static func value<T: Mappable>(_ jsonValue: String?, Target: T.Type) -> T? {
        guard let jsonValue = jsonValue else {return nil}
        return Target.init(JSONString: jsonValue)
    }
}
