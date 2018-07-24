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
        do {
            let scheme = try urlScheme.unwrap()
            navigator.register(scheme) { (url, values, context) -> UIViewController? in
                return self.createWebController(url, values: values, context: context)
            }
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    private func registerDoAlertRouter(_ urlScheme: String?) {
        do {
            let scheme = try urlScheme.unwrap()
            navigator.register(scheme) { (url, values, context) -> UIViewController? in
                do {
                    let style: String = try values.forKey("style").unwrap()
                    let alertStyle: UIAlertControllerStyle = style == "alert" ? .alert : .actionSheet
                    let title: String = try url.queryParameters["title"].unwrap()
                    let message: String = try url.queryParameters["message"].unwrap()
                    return self.createAlertController(url, style: alertStyle, title: title, message: message, context: context)
                } catch {
                    return MolueLogger.failure.returnNil(error)
                }
            }
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    private func registerNavigatorRouter(_ urlScheme: String?) {
        do {
            let scheme = try urlScheme.unwrap()
            navigator.register(scheme) { [unowned self] (url, values, context) -> UIViewController? in
                do {
                    let fileName: String = try values.forKey("fileName").unwrap()
                    return self.createViewController(url, filename: fileName, context: context)
                } catch {
                    return MolueLogger.failure.returnNil(error)
                }
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func createAlertController(_ url: URLConvertible, style: UIAlertControllerStyle, title: String, message: String, context: Any?) -> UIViewController? {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        if let actions:[UIAlertAction] = context as? [UIAlertAction] {
            controller.addActions(actions)
        } else {
            controller.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
        }
        return controller
    }
    
    private func createWebController(_ url: URLConvertible, values: [String: Any]?, context: Any?) -> UIViewController? {
        return nil
    }
    
    private func createViewController(_ url: URLConvertible, filename: String, context: Any?) -> UIViewController? {
        do {
            let URL = try url.urlValue.unwrap()
            let module = try URL.host.unwrap()
            let viewController = self.instantiateViewController(module: module, filename: filename)
            self.updateViewController(viewController, params: URL.query, context: context)
            return viewController
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    private func instantiateViewController(module: String, filename: String) -> UIViewController? {
        do {
            let bundle = try Bundle.create(module: module).unwrap()
            let storyboard = UIStoryboard.init(name: filename, bundle: bundle)
            let tempClass: AnyClass = try NSClassFromString(module + "." + filename).unwrap()
            let targetClass = try (tempClass as? UIViewController.Type).unwrap()
            return storyboard.instantiateViewController(withClass: targetClass.self)
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    private func updateViewController(_ viewController: UIViewController?, params: String?, context: Any?) {
        guard let controller = viewController as? MolueNavigatorProtocol else {return}
        do {
            controller.doTransferParameters(params: context)
            let value = try params.unwrap().removingPercentEncoding.unwrap()
            controller.doSettingParameters(params: value)
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    private func updateRouterURL(_ url: String, parameters: Mappable?) -> String {
        do {
            var component = try URLComponents(string: url).unwrap()
            let parameters = try parameters.unwrap()
            component.query = parameters.toJSONString()
            return try component.url.unwrap().absoluteString
        } catch {
            MolueLogger.failure.message(error)
            return url
        }
    }
}

extension MolueAppRouter {
    public func viewController<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil) -> T? {
        do {
            let url = try router.toString().unwrap()
            let newURL = self.updateRouterURL(url, parameters: parameters)
            let controller = try navigator.viewController(for: newURL, context: context).unwrap()
            return try controller.toTarget().unwrap()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    @discardableResult
    public func push<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true, needHideBottomBar: Bool! = false) -> T? {
        do {
            let viewController = try self.viewController(router, parameters: parameters, context: context).unwrap()
            viewController.hidesBottomBarWhenPushed = needHideBottomBar
            let controller = try navigator.pushViewController(viewController, from: from, animated: animated).unwrap()
            return try controller.toTarget().unwrap()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    @discardableResult
    public func present<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> T? {
        do {
            let viewController = try self.viewController(router, parameters: parameters, context: context).unwrap()
            let controller = try navigator.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion).unwrap()
            return try controller.toTarget().unwrap()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    @discardableResult
    public func handler(for router: MolueWebsiteRouter,  parameters: Mappable? = nil, context: Any?) -> URLOpenHandler? {
        do {
            let url = try router.toString().unwrap()
            let newURL = self.updateRouterURL(url, parameters: parameters)
            return navigator.handler(for: newURL, context: context)
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    @discardableResult
    public func showAlert(_ router: MolueDoAlertRouter, actions:[UIAlertAction]? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        do {
            let url = try router.toString().unwrap()
            let viewController = try navigator.viewController(for: url, context: actions).unwrap()
            return navigator.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
}

extension MolueAppRouter {
    @discardableResult
    public func present(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return navigator.present(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    public func push(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
         return navigator.pushViewController(viewController, from: from, animated: animated)
    }
}
