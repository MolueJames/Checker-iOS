//
//  MolueAppRoute+Extension.swift
//  MolueNavigator
//
//  Created by MolueJames on 2018/9/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper
import MolueUtilities
import URLNavigator
extension MolueAppRouter {
    public func viewController<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil) -> T? {
        do {
            let url = try router.toString().unwrap()
            let newURL = self.updateRouterURL(url, parameters: parameters)
            let controller = try navigator.viewController(for: newURL, context: context).unwrap()
            return try controller.toTarget()
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
            return try controller.toTarget()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }

    @discardableResult
    public func present<T: UIViewController>(_ router: MolueNavigatorRouter, parameters: Mappable? = nil, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> T? {
        do {
            let viewController = try self.viewController(router, parameters: parameters, context: context).unwrap()
            let controller = try navigator.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion).unwrap()
            return try controller.toTarget()
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
    private func updateRouterURL(_ url: String, parameters: Mappable?) -> String {
        do {
            var component = try URLComponents(string: url).unwrap()
            let parameters = try parameters.unwrap()
            component.query = parameters.toJSONString()
            return try component.url.unwrap().absoluteString
        } catch { return url }
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
