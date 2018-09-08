//
//  AppDelegate+KeyBoard.swift
//  MolueSafty
//
//  Created by James on 2018/4/29.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import LeakEye
import MolueUtilities
import IQKeyboardManagerSwift
extension AppDelegate {
    func initializeIQKeyBoardConfigure() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
    }
}

extension AppDelegate: LeakEyeDelegate {
    func initializeLeakEyeConfigure() {
        self.leakEye.delegate = self
        self.leakEye.open()
    }
    
    func leakEye(_ leakEye:LeakEye ,didCatchLeak object: NSObject) {
        fatalError("\(object) has not dealloc, please check code!")
    }
}
