//
//  Appdelegate+UILogic.swift
//  MolueSafty
//
//  Created by James on 2018/4/27.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNavigator
import MolueMinePart
import MolueFoundation
import MolueUtilities
import MolueCommon
import MolueMediator
import ObjectMapper
import MolueNetwork
import MolueDatabase

extension AppDelegate {
    func setDefaultRootViewController() {
        self.setAppWindowConfiguration()
        self.setUserLoginNotification()
        self.setNeedLoginNotification()
    }
    
   private func setUserLoginNotification() {
        let name = MolueNotification.molue_user_login.toName()
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: OperationQueue.main) { [unowned self] (_) in
            self.window?.rootViewController = self.rootViewController()
            self.window?.makeKeyAndVisible()
        }
    }
    
    private func setNeedLoginNotification() {
        let name = MolueNotification.molue_need_login.toName()
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: OperationQueue.main) { [unowned self] (_) in
            MolueUserLogic.disconnectWithDatabase()
            self.window?.rootViewController = self.loginViewController()
            self.window?.makeKeyAndVisible()
        }
    }
    
    public func setAppWindowConfiguration() {
        do {
            let window = try self.window.unwrap()
            window.isHidden = false
            self.setRootViewController(for: window)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func setRootViewController(for window: UIWindow) {
        do {
            try MolueUserLogic.connectWithLastDatabase()
            window.rootViewController = self.rootViewController()
        } catch {
            window.rootViewController = self.loginViewController()
        }
//        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
    }
    
    private func loginViewController() -> UIViewController? {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.LoginPage)
            let builder: UserLoginPageComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            return MLNavigationController(rootViewController: controller)
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }
    
    private func rootViewController() -> UIViewController {
        var viewControllers = [MLNavigationController]()
        self.buildHomePartEnter(with: &viewControllers)
        self.buildBookPartEnter(with: &viewControllers)
        self.buildCheckPartEnter(with: &viewControllers)
        self.buildChatPartEnter(with: &viewControllers)
        self.buildMinePartEnter(with: &viewControllers)
        
        let tabbarController = MLTabBarController()
        tabbarController.viewControllers = viewControllers
        return tabbarController
    }
    
    private func addNavigationController(module: MolueNavigatorRouter.RouterHost, path: String, viewControllers: inout [MLNavigationController], title: String, imageName: String) {
        do {
            let router = MolueNavigatorRouter(module, path: path)
            let viewController = try MolueAppRouter.shared.viewController(router).unwrap()
            viewController.tabBarItem = UITabBarItem(title: title, image: UIImage.init(named: imageName), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: viewController))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func buildBookPartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Book>(.BookInfo)
            let builder: BookInfoComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "文书", image: UIImage.init(named: "molue_tabbar_book"), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: controller))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func buildChatPartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Book>(.ChatPage)
            let builder: AppChatPageComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "聊天", image: UIImage.init(named: "molue_tabbar_chat"), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: controller))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func buildMinePartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Mine>(.UserCenter)
            let builder: UserInfoCenterComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "我的", image: UIImage.init(named: "molue_tabbar_mine"), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: controller))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func buildHomePartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Home>(.HomeInfoPage)
            let builder: HomeInfoPageComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "首页", image: UIImage.init(named: "molue_tabbar_home"), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: controller))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func buildCheckPartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.QuickCheck)
            let builder: QuickCheckRiskComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "检查", image: UIImage.init(named: "molue_quick_check"), tag: viewControllers.count)
            viewControllers.append(MLNavigationController(rootViewController: controller))
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
