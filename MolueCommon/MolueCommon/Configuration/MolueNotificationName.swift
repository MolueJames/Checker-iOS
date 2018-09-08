//
//  MolueNotificationName.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/7/26.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MolueToNotification {
    func toName() -> NSNotification.Name
}

public enum MolueNotification: String {
    // MARK: - 用户需要登录操作
    case molue_need_login = "molue_need_login"
    // MARK: - 用户登录成功
    case molue_user_login = "molue_user_login"
    // MARK: - 用户取消登录操作
    case molue_user_cancel = "molue_user_cancel"
    // MARK: - 用户退出成功
    case molue_user_logout = "molue_user_logout"
}

extension MolueNotification: MolueToNotification {
    public func toName() -> NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}
