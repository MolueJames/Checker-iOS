//
//  MLInterfaceConfigure.swift
//  MolueCommon
//
//  Created by James on 2018/5/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities

public class MLInterfaceConfigure {
    private static func navigationBarAppearance() {
        let navigationBar = UINavigationBar.appearance()
        let image = UIImage.init(color: .clear, size: CGSize.init(width: MLConfigure.ScreenWidth, height: 64))
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.backIndicatorImage = UIImage.init(named: "common_navigation_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "common_navigation_back")
        navigationBar.shadowImage = UIImage()
    }
    
    private static func barButtonItemAppearance() {
        let item = UIBarButtonItem.appearance(whenContainedInInstancesOf:[UINavigationBar.self])
        let itemAttributesDic = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
        item.setTitleTextAttributes(itemAttributesDic, for: .normal)
    }
    
    private static func setViewsAppearanceConfigure() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
    
    private static func updateUITabBarAppearance() {
        let tabBar = UITabBar.appearance(whenContainedInInstancesOf: [UITabBarController.self])
        tabBar.tintColor = UIColor.init(hex: 0x1B82D2)
        tabBar.backgroundImage = UIImage.init(color: .white, size: CGSize.init(width: MLConfigure.ScreenWidth, height: 49))
    }
    
    public static func setInterfaceConfigure() {
        self.barButtonItemAppearance()
        self.navigationBarAppearance()
        self.updateUITabBarAppearance()
        self.setViewsAppearanceConfigure()
    }
}
