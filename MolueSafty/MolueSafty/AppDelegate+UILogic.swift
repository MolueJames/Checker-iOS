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
        self.addNavigationController(module: .Home, path: HomeFilePath.HomeInfo, viewControllers: &viewControllers)
        self.addNavigationController(module: .Mine, path: MineFilePath.MineInfo, viewControllers: &viewControllers)
        self.addNavigationController(module: .Risk, path: RiskFilePath.RiskInfo, viewControllers: &viewControllers)
        self.addNavigationController(module: .Document, path: DocumentPath.DocumentInfo, viewControllers: &viewControllers)
        
        let tabbarController = MLTabBarController.init()
        tabbarController.viewControllers = viewControllers
        return tabbarController
    }
    
    private func addNavigationController(module: MolueNavigatorRouter.RouterHost, path: String, viewControllers: inout [MLNavigationController]){
        let homeInfoRouter = MolueNavigatorRouter.init(module, path: path)
        guard let homeInfoViewController = MolueAppRouter.sharedInstance.viewController(homeInfoRouter) else { return }
        viewControllers.append(MLNavigationController.init(rootViewController: homeInfoViewController))
    }
}
