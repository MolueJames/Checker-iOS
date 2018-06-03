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
import MolueCommon

extension AppDelegate {
    func setDefaultRootViewController() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.isHidden = false
        self.window?.rootViewController = self.rootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    private func rootViewController() -> UIViewController {
        MolueAppRouter.sharedInstance.initialize()
        var viewControllers = [MLNavigationController]()
        self.addNavigationController(module: .Home, path: HomeFilePath.HomePageInfo, viewControllers: &viewControllers, title:"首页", imageName: "molue_tabbar_home")
        self.addNavigationController(module: .Risk, path: RiskFilePath.RiskInfo, viewControllers: &viewControllers, title:"隐患", imageName: "molue_tabbar_risk")
        self.addNavigationController(module: .Book, path: BookFilePath.BookInfo, viewControllers: &viewControllers, title:"文书", imageName: "molue_tabbar_book")
        self.addNavigationController(module: .Mine, path: MineFilePath.MineInfo, viewControllers: &viewControllers, title:"我的", imageName: "molue_tabbar_mine")
        
        let tabbarController = MLTabBarController.init()
        tabbarController.viewControllers = viewControllers
        return tabbarController
    }
    
    private func addNavigationController(module: MolueNavigatorRouter.RouterHost, path: String, viewControllers: inout [MLNavigationController], title: String, imageName: String){
        let router = MolueNavigatorRouter(module, path: path)
        guard let viewController = MolueAppRouter.sharedInstance.viewController(router) else { return }
        viewController.tabBarItem = UITabBarItem.init(title: title, image: UIImage.init(named: imageName), tag: viewControllers.count)
        viewControllers.append(MLNavigationController.init(rootViewController: viewController))
    }
}
