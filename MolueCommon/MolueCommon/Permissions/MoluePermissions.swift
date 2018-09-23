//
//  MoluePermissions.swift
//  MolueCommon
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

//import Foundation
//import Permission
//public class MoluePermission {
//
//    public static func locationAlways(_ callback: @escaping Permission.Callback) {
//        let permission: Permission = .locationAlways
//
//        // 已经被拒绝的情况
//        let deniedAlert = permission.deniedAlert // or permission.disabledAlert
//        deniedAlert.title    = " locationAlways"
//        deniedAlert.message  = nil
//        deniedAlert.cancel   = "Cancel"
//        deniedAlert.settings = "Settings"
//
//        // 在弹出以前先询问一次
//        permission.presentPrePermissionAlert = true
//        let prePermissionAlert = permission.prePermissionAlert
//        prePermissionAlert.title   = "locationAlways?"
//        prePermissionAlert.message = ""
//        prePermissionAlert.cancel  = "Not now"
//        prePermissionAlert.confirm = "Give Access"
//        permission.request(callback)
//    }
//
//    public static func locationWhenInUse(_ callback: @escaping Permission.Callback) {
//        let permission: Permission = .locationWhenInUse
//
//        // 已经被拒绝的情况
//        let deniedAlert = permission.deniedAlert // or permission.disabledAlert
//        deniedAlert.title    = " locationWhenInUse"
//        deniedAlert.message  = nil
//        deniedAlert.cancel   = "Cancel"
//        deniedAlert.settings = "Settings"
//
//        // 在弹出以前先询问一次
//        permission.presentPrePermissionAlert = true
//        let prePermissionAlert = permission.prePermissionAlert
//        prePermissionAlert.title   = "locationWhenInUse?"
//        prePermissionAlert.message = ""
//        prePermissionAlert.cancel  = "Not now"
//        prePermissionAlert.confirm = "Give Access"
//        permission.request(callback)
//    }
//
//    public static func camera(_ callback: @escaping Permission.Callback) {
//        let permission: Permission = .camera
//
//        // 已经被拒绝的情况
//        let deniedAlert = permission.deniedAlert // or permission.disabledAlert
//        deniedAlert.title    = " camera"
//        deniedAlert.message  = nil
//        deniedAlert.cancel   = "Cancel"
//        deniedAlert.settings = "Settings"
//
//        // 在弹出以前先询问一次
//        permission.presentPrePermissionAlert = false
//        let prePermissionAlert = permission.prePermissionAlert
//        prePermissionAlert.title   = "camera?"
//        prePermissionAlert.message = ""
//        prePermissionAlert.cancel  = "Not now"
//        prePermissionAlert.confirm = "Give Access"
//        permission.request(callback)
//    }
//
//    static func notifications(_ callback: @escaping Permission.Callback) {
//        let permission: Permission = .notifications
//
//        // 已经被拒绝的情况
//        let deniedAlert = permission.deniedAlert // or permission.disabledAlert
//        deniedAlert.title    = " notifications"
//        deniedAlert.message  = nil
//        deniedAlert.cancel   = "Cancel"
//        deniedAlert.settings = "Settings"
//
//        // 在弹出以前先询问一次
//        permission.presentPrePermissionAlert = false
//        let prePermissionAlert = permission.prePermissionAlert
//        prePermissionAlert.title   = "notifications?"
//        prePermissionAlert.message = ""
//        prePermissionAlert.cancel  = "Not now"
//        prePermissionAlert.confirm = "Give Access"
//        permission.request(callback)
//    }
//
//}
