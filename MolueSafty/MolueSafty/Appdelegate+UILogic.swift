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
extension AppDelegate {
    func setDefaultRootViewController() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.isHidden = false
        self.window?.rootViewController = self.rootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    private func rootViewController() -> UIViewController? {
        MolueAppRouter.sharedInstance.initialize()
        let mineInforRouter = MolueNavigatorRouter.init(.Mine, path: "MineInforViewController")
        let mineInforviewcontroller = MolueAppRouter.sharedInstance.viewController(mineInforRouter)
        return mineInforviewcontroller
    }
}
