//
//  MolueAppRouter.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import URLNavigator
protocol MolueRouterProtocol {
    func toString() -> String?
    var components: URLComponents {get set}
}

let single = MolueAppRouter()
public class MolueAppRouter {
    let navigator = Navigator()
    public static var sharedInstance : MolueAppRouter {
        return single
    }
    
    public func initialize() {
        if let homeRouter = MolueNavigatorRouter(.Home, path: "<fileName>").toString() {
            navigator.register(homeRouter) { (url, values, context) -> UIViewController? in
                guard let fileName = values["fileName"] as? String else { return nil }
                return nil
            }
        }
        if let mineRouter = MolueNavigatorRouter(.Mine, path: "<fileName>").toString() {
            navigator.register(mineRouter) { (url, values, context) -> UIViewController? in
                guard let fileName = values["fileName"] as? String else { return nil }
                return nil
            }
        }
//        if let alertRouter = MolueRouterPattern.navigator(.alert).toString() {
//            navigator.register(alertRouter) { (url, values, context) -> UIViewController? in
//                guard let title = values["title"] as? String else {return nil}
//                guard let message = values["message"] as? String else {return nil}
//                return nil
//            }
//        }
//        if let httpRouter = MolueWebsiteRouter.init(.HTTP, path: "<path:_>").toString() {
//            navigator.handle(httpRouter) { (url, values, context) -> Bool in
//                return true
//            }
//        }
//        if let httpsRouter = MolueWebsiteRouter.init(.HTTPS, path: "<path:_>").toString() {
//            navigator.handle(httpsRouter) { (url, values, context) -> Bool in
//                return true
//            }
//        }
    }

//
    func viewController(_ router: MolueRouterProtocol) {
        
    }
}
