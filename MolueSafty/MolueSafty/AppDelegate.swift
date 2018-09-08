//
//  AppDelegate.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueDatabase
import MolueUtilities
import MolueCommon
import MolueNetwork
import Alamofire
import LeakEye
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow.init(frame: UIScreen.main.bounds)
    var leakEye = LeakEye()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerJPushWithlaunchOptions(launchOptions)
        self.setUserInterfaceConfigure()
        self.setDefaultRootViewController()
        self.initializeIQKeyBoardConfigure()
        self.initializeLeakEyeConfigure()
//        let headerInfo = Alamofire.Request.authorizationHeader(user: "hj8LAJukEhrs37yPbvXlwX5kG8sk45q0gciIw1Ol", password: "jEOk3ZLDixlJWPyyoncEbcwp4z3Ij5VG05HfKGORg5357CCWeRnrY86OPFpCPF79FaRiUGHnUcb68uCp5NScHg3z5roBqkVY3eB2LHrEaByULCY4JFMRDvXTa7a3ITq9")
//        guard let header = headerInfo else {return true}
//        let xxx = [header.key : header.value]
//        let dict = ["username":"13063745829", "password":"q1w2e3r4","grant_type":"password"]
//
//        let request = MolueDataRequest.init(parameter:dict, method: .post, path: "oauth/token/", headers: xxx)
//        let manager = MolueRequestManager(request: request)
//        manager.handleFailureResponse { (error) in
//            print(error.localizedDescription)
//            print(error)
//
//        }
//
//        manager.handleSuccessResultToObjc { (result: MolueOauthModel?) in
//            print(result)
//            print(result?.validateNeedRefresh())
//        }
//        manager.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
