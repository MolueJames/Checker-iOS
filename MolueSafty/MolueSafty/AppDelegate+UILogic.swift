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

extension AppDelegate {
    func setDefaultRootViewController() {
        self.setAppWindowConfigure()
        let name = MolueNotification.molue_user_login.toName()
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: OperationQueue.main) { [unowned self] (_) in
            self.window?.rootViewController = self.rootViewController()
            self.window?.makeKeyAndVisible()
        }
    }
    
    public func setAppWindowConfigure() {
        do {
            let window = try self.window.unwrap()
            window.isHidden = false
            let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.LoginPage)
            let builder: UserLoginPageComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            let navController = MLNavigationController(rootViewController: controller)
            window.rootViewController = navController
            window.makeKeyAndVisible()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func rootViewController() -> UIViewController {
        var viewControllers = [MLNavigationController]()
//        self.addNavigationController(module: .Home, path: HomePath.HomePageInfo.rawValue, viewControllers: &viewControllers, title:"首页", imageName: "molue_tabbar_home")
        self.buildRiskPartEnter(with: &viewControllers)
//        self.addNavigationController(module: .Book, path: BookPath.BookInfo.rawValue, viewControllers: &viewControllers, title:"文书", imageName: "molue_tabbar_book")
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
    
    private func buildRiskPartEnter(with viewControllers: inout [MLNavigationController]) {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.RiskList)
            let builder: PotentialRiskComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build()
            controller.tabBarItem = UITabBarItem(title: "隐患", image: UIImage.init(named: "molue_tabbar_risk"), tag: viewControllers.count)
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
}
