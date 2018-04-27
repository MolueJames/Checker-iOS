//
//  MolueAppRouter.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import URLNavigator
public protocol MolueRouterProtocol {
    /// to create router url
    ///
    /// - Returns: router url
    func toString() -> String?
}

public protocol MolueNavigatorProtocol {
    /// transfer parameters
    ///
    /// - Parameter params: for business logic
    func doTransferParameters(params: Any?)
    /// transfer parameters
    ///
    /// - Parameter params: for user interface
    func doSettingParameters(params:Dictionary<String, String>)
}

let single = MolueAppRouter()
public class MolueAppRouter {
    let navigator = Navigator()
    public static var sharedInstance : MolueAppRouter {
        return single
    }
    
    public func initialize() {
        if let homeRouter = MolueNavigatorRouter(.Home, path: "<fileName>").toString() {
            navigator.register(homeRouter) { [unowned self] (url, values, context) -> UIViewController? in
                guard let fileName = values["fileName"] as? String else { return nil }
                let viewcontroller = self.createViewController(url, filename: fileName, context: context)
                return viewcontroller
            }
        }
        if let mineRouter = MolueNavigatorRouter(.Mine, path: "<fileName>").toString() {
            navigator.register(mineRouter) { [unowned self] (url, values, context) -> UIViewController? in
                guard let fileName = values["fileName"] as? String else { return nil }
                let viewcontroller = self.createViewController(url, filename: fileName, context: context)
                return viewcontroller
            }
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
//    }

//
        
    private func createViewController(_ url: URLConvertible, filename: String, context: Any?) -> UIViewController? {
        guard let components = URLComponents.init(string: url.urlStringValue) else {return nil}
        guard let module = components.host else {return nil}
        var classname = module + "." + filename
        classname = classname.replacingOccurrences(of: "/", with: "")
        guard let Class : AnyClass = NSClassFromString(classname) else {return nil}
        guard let targetClass = Class as? UIViewController.Type else {return nil}
        return targetClass.init()
    }
    
    private func updateViewController(_ viewController: UIViewController?, params:Dictionary<String,String>, context: Any?) {
        if let controller = viewController as? MolueNavigatorProtocol {
            controller.doTransferParameters(params: context)
            controller.doSettingParameters(params: params)
        }
    }
    
    private func updateRouterURL(_ url: String, parameters: [String: Any]?) -> String {
        guard let parameters = parameters else {return url}
        let query = QueryUtilities.query(parameters)
        guard query.isEmpty == false else {return url}
        let connector = (URL.init(string: url)?.query) == nil  ? "?" : "&"
        return url + connector + query
    }
    
    public func viewController(_ router: MolueRouterProtocol, parameters: [String: Any]? = nil, context: Any? = nil) -> UIViewController? {
        guard let url = router.toString() else {return nil}
        let newURL = self.updateRouterURL(url, parameters: parameters)
        return navigator.viewController(for: newURL, context: context)
    }
}
