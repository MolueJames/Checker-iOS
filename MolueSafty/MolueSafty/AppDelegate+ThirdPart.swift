//
//  AppDelegate+KeyBoard.swift
//  MolueSafty
//
//  Created by James on 2018/4/29.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
extension AppDelegate {
    func initializeIQKeyBoardConfigure() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
    }
}
