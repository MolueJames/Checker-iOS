//
//  MolueAppRouter.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import URLNavigator
import MolueUtilities
import ObjectMapper

fileprivate let single = MolueAppRouter()
public class MolueAppRouter {
    fileprivate let navigator = Navigator()
    public static var shared : MolueAppRouter {
        return single
    }
    
    public func initialize() {
        self.registerNavigatorRouter(MolueNavigatorRouter(.Home, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Mine, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Risk, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Book, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Common, path: "<fileName>").toString())
     
        self.registerWebsiteRouter(MolueWebsiteRouter(.HTTP, path: "<path:_>").toString())
        
        self.registerWebsiteRouter(MolueWebsiteRouter(.HTTPS, path: "<path:_>").toString())
        
        self.registerDoAlertRouter(MolueDoAlertRouter.init("<style>").toPath())
    }
    
    private func registerWebsiteRouter(_ urlScheme: String?) {
        guard let scheme = urlScheme else {
            MolueLogger.UIModule.error("the scheme is not existed"); return
        }
        navigator.register(scheme) { (url, values, context) -> UIViewController? in
            return self.createWebController(url, values: values, context: context)
        }
    }
    
    private func registerDoAlertRouter(_ urlScheme: String?) {
        guard let scheme = urlScheme else {
            MolueLogger.UIModule.error("the scheme is not existed"); return
        }
        navigator.register(scheme) { (url, values, context) -> UIViewController? in
            guard let style = values["style"] as? String else {
                return MolueLogger.failure.returnNil("The style is not String")
            }
            let alertStyle: UIAlertControllerStyle = style == "alert" ? .alert : .actionSheet
            let title = url.queryParameters["title"]
            let message = url.queryParameters["message"]
            return self.createAlertController(url, style: alertStyle, title: title, message: message, context: context)
        }
    }
    
    private func registerNavigatorRouter(_ urlScheme: String?) {
        guard let scheme = urlScheme else {
            MolueLogger.UIModule.error("the scheme is not existed"); return
        }
        navigator.register(scheme) { [unowned self] (url, values, context) -> UIViewController? in
            guard let fileName = values["fileName"] as? String else {
                return MolueLogger.failure.returnNil("The style is not String")
            }
            return self.createViewController(url, filename: fileName, context: context)
        }
    }
    
    private func createAlertController(_ url: URLConvertible, style: UIAlertControllerStyle, title: String?, message: String?, context: Any?) -> UIViewController? {
        guard let title = title else {
            return MolueLogger.failure.returnNil("The title is nil")
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if let actions:[UIAlertAction] = context as? [UIAlertAction] {
            alertController.addActions(actions)
        } else {
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        return alertController
    }
    
    private func createWebController(_ url: URLConvertible, values: [String: Any]?, context: Any?) -> UIViewController? {
        return nil
    }
    
    private func createViewController(_ url: URLConvertible, filename: String, context: Any?) -> UIViewController? {
        guard let URL = url.urlValue else {
            return MolueLogger.failure.returnNil("The component is not existed")
        }
        guard let module = URL.host else {
            return MolueLogger.failure.returnNil("The module is not existed")
        }
        let viewController = self.instantiateViewController(module: module, filename: filename)
        self.updateViewController(viewController, params: URL.query, context: context)
        return viewController
    }
    
    private func instantiateViewController(module: String, filename: String) -> UIViewController? {
        guard let bundle = Bundle.create(module: module) else {
            return MolueLogger.failure.returnNil("The bundle is not existed")
        }
        let storyboard = UIStoryboard.init(name: filename, bundle: bundle)
        guard let Class : AnyClass = NSClassFromString(module + "." + filename) else {
            return MolueLogger.failure.returnNil("The class is not existed")
        }
        guard let targetClass = Class as? UIViewController.Type else {
            return MolueLogger.failure.returnNil("The targetClass is not UIViewController")
        }
        return storyboard.instantiateViewController(withClass:targetClass.self)
    }
    
    private func updateViewController(_ viewController: UIViewController?, params: String?, context: Any?) {
        guard let controller = viewController as? MolueNavigatorProtocol else {return}
        controller.doTransferParameters(params: context)
        controller.doSettingParameters(params: params?.removingPercentEncoding)
    }
    
    private func updateRouterURL(_ url: String, parameters: Mappable?) -> String {
        guard let parameters = parameters else {return url}
        guard let query = parameters.toJSONString() else {return url}
        guard query.isEmpty == false else {return url}
        let connector = (URL.init(string: url)?.query) == nil  ? "?" : "&"
        return url + connector + query
    }
}

extension MolueAppRouter {
    public func viewController<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil) -> T? {
        guard let url = router.toString() else {
            return MolueLogger.failure.returnNil("The url is not existed")
        }
        let newURL = self.updateRouterURL(url, parameters: parameters)
        guard let controller = navigator.viewController(for: newURL, context: context) else {
            return MolueLogger.failure.returnNil("the viewcontroller is not existed")
        }
        guard let aController = controller as? T else {
            return MolueLogger.failure.returnNil("the viewcontroller is not \(T.self)")
        }
        return aController
    }
    
    @discardableResult
    public func push<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true, needHideBottomBar: Bool! = false) -> T? {
        guard let viewController = self.viewController(router, parameters: parameters, context: context) else {
            return MolueLogger.failure.returnNil("The viewController is not existed")
        }
        viewController.hidesBottomBarWhenPushed = needHideBottomBar
        return navigator.pushViewController(viewController, from: from, animated: animated) as? T
    }
    
    @discardableResult
    public func present<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> T? {
        guard let viewController = self.viewController(router, parameters: parameters, context: context) else {
            return MolueLogger.failure.returnNil("The viewController is not existed")
        }
        return navigator.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion) as? T
    }
    
    @discardableResult
    public func handler(for router: MolueWebsiteRouter,  parameters: Mappable? = nil, context: Any?) -> URLOpenHandler? {
        guard let url = router.toString() else {
            return MolueLogger.failure.returnNil("The url is not existed")
        }
        let newURL = self.updateRouterURL(url, parameters: parameters)
        return navigator.handler(for: newURL, context: context)
    }
    
    @discardableResult
    public func showAlert(_ router: MolueDoAlertRouter, actions:[UIAlertAction]? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController?{
        guard let url = router.toString() else {
            return MolueLogger.failure.returnNil("The url is not existed")
        }
        guard let viewcontroller = navigator.viewController(for: url, context: actions) else {
            return MolueLogger.failure.returnNil("The viewController is not existed")
        }
        return navigator.present(viewcontroller, wrap: wrap, from: from, animated: animated, completion: completion)
    }
}
