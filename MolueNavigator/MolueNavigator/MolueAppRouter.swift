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
    internal let navigator = Navigator()
    public static var shared : MolueAppRouter {
        return single
    }
    
    public func initialize() {
        self.registerNavigatorRouter(MolueNavigatorRouter(.Home, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Mine, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Risk, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Book, path: "<fileName>").toString())
        
        self.registerNavigatorRouter(MolueNavigatorRouter(.Login, path: "<fileName>").toString())
        
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
        do {
            let actions:[UIAlertAction] = try validateTarget(context)
            controller.addActions(actions)
        } catch {
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
            let viewController = self.initializeViewController(module: module, filename: filename)
            self.updateViewController(viewController, params: URL.query, context: context)
            return viewController
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    private func initializeViewController(module: String, filename: String) -> UIViewController? {
        func initializeTargetController(target: UIViewController.Type) -> UIViewController? {
            do {
                let theClass = try (target as? MolueVIPBuilderProtocol.Type).unwrap()
                return theClass.doBulildVIPComponent()
            } catch {
                return target.initializeFromStoryboard()
            }
        }
        do {
            let targetClass: AnyClass = try NSClassFromString(module + "." + filename).unwrap()
            let target = try (targetClass as? UIViewController.Type).unwrap()
            return initializeTargetController(target: target)
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    private func updateViewController(_ viewController: UIViewController?, params: String?, context: Any?) {
        guard let controller = viewController as? MolueNavigatorProtocol else {return}
        do {
            controller.doTransferParameters(params: context)
            let tempValue = try params.unwrap()
            let value = try tempValue.removingPercentEncoding.unwrap()
            controller.doSettingParameters(params: value)
        } catch {
            MolueLogger.failure.message(error)
        }
    }
    

}
