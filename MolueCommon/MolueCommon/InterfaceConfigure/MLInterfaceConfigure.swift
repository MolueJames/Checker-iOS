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
        let image = UIImage.init(color: UIColor.clear, size: CGSize.init(width: MLConfigure.screenWidth, height: 64))
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.tintColor = UIColor.black
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0x030303) ?? UIColor.white]
        navigationBar.backIndicatorImage = UIImage.init(named: "common_navigation_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "common_navigation_back")
    }
    private static func barButtonItemAppearance() {
//        UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]];
//        NSDictionary *itemAttributesDic = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor color_From_HEX_String:@"2979FF"]};
//        [item setTitleTextAttributes:itemAttributesDic forState:UIControlStateNormal];
    }
    
    private static func updateTextFieldAppearance() {
//    [[UITextField appearance] setTintColor:[[UIColor color_From_HEX_String:@"FF5F5F"] colorWithAlphaComponent:0.7]];
//    if (@available(iOS 11.0, *)) {
//    [[UITableView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    }
    
    private static func updateUITabBarAppearance() {
//    UITabBar *tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:@[[BaseTabBarController class]]];
//    tabBar.tintColor = [UIColor color_From_HEX_String:@"FF5F5F"];
//    tabBar.backgroundImage = [UIImage image_From_Color:[UIColor whiteColor] Size:CGSizeMake(SCREEN_WIDTH(), 49)];
    }
    public static func setInterfaceConfigure() {
        barButtonItemAppearance()
        navigationBarAppearance()
        updateUITabBarAppearance()
        updateTextFieldAppearance()
    }
}
