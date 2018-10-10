//
//  UIViewController+MolueMediator.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/2.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities

extension UIViewController {
    private class var sharedApplication: UIApplication? {
        do {
            let selector = NSSelectorFromString("sharedApplication")
            let object = try UIApplication.perform(selector).unwrap()
            let instance = object.takeUnretainedValue() as? UIApplication
            return try instance.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }
    
    open class var topMost: UIViewController? {
        do {
            let currentWindows = try self.sharedApplication.unwrap().windows
            var rootViewController: UIViewController?
            currentWindows.forEach(where: { (window) -> Bool in
                return ((window.rootViewController != nil))
            }) { (window) in
                rootViewController = window.rootViewController
            }
            return self.topMost(of: rootViewController)
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }
    
    open class func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
