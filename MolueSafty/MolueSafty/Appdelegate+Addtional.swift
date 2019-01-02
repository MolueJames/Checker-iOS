//
//  Appdelegate+Interface.swift
//  MolueSafty
//
//  Created by James on 2018/5/12.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNetwork
import MolueCommon
import KeychainAccess
import Kingfisher
import Alamofire
import MolueUtilities

import MolueMediator
import BoltsSwift
import MolueHomePart

extension AppDelegate {
    func setUserInterfaceConfigure() {
        MLInterfaceConfigure.setInterfaceConfigure()
        self.setDefaultWebImageConfigure()
        
        Task.whenAll([self.queryDetail(), self.queryDetail()]).continueOnSuccessWith { (result) in
            MolueLogger.network.message(result)
//            self.queryDetail()
        }
    }
    
    
    private func testTask(index: Int) -> Task<Any?> {
        let taskCompletionSource = TaskCompletionSource<Any?>()
        let image = UIImage(named: "task_report_selected")
        MolueFileService.uploadPicture(with: image!, success: { (result) in
            if (index == 3 || index ==  4) {
                let error = NSError(domain: "bolts", code: 1, userInfo: nil)
                taskCompletionSource.set(error: error)
            } else {
                taskCompletionSource.set(result: result)
            }
            
        }) { (error) in
            taskCompletionSource.set(result: error)
        }
        return taskCompletionSource.task
    }
    
    
    
    private func uploadFiles() {
        var tasks = [Task<Any?>]()
        for i in 0...10 {
            tasks.append(testTask(index: i))
        }
        
//        Task.whenAll(tasks).continueOnSuccessWith { task in
//            dump(task)
//        }.continueOnErrorWith { (error) in
//            dump(error)
//        }
    }
    
    
    private func queryPlan() {
        let request = MolueCheckService.queryDailyPlanList(page: 1, pagesize: 10)
        
        request.handleSuccessResponse { (result) in
            MolueLogger.network.message(result)
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func queryDetail() -> Task<Any?> {
        let request = MolueCheckService.queryDailyCheckTask(with: "2018-12-24-002-013")
        request.handleSuccessResultToObjc { (result: MLDailyCheckTask?) in
            dump(result?.toJSONString())
        }
        request.handleSuccessResponse { (result) in
            MolueLogger.network.message(result)
        }
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error)
        }
        let requestManager = MolueRequestManager()
        return requestManager.doRequestStart(with: request)
//        requestManager.doRequestStart(with: request)
//        requestManager.doRequestStart(with: request)
    }
    
    private func uploadFile() {
        
        let a = MLTaskAttachment();
        a.result = "xxxx"
        dump(a.toJSON())
        
        let image = UIImage(named: "task_report_selected")
        MolueFileService.uploadPicture(with: image!, success: { (result) in
            MolueLogger.network.message(result)
//            guard let result = result as? [String : String] else {return}
//            MolueLogger.network.message(result["id"])
        }) { (error) in
            MolueLogger.network.message(error)
        }
    }
    
    private func networkLoginRequest() -> Task<Any?>{
        let request = MolueOauthService.doLogin(username: "182828282828", password: "-1234Asdf")
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error.localizedDescription)
        }
        request.handleSuccessResultToObjc { (result: MolueOauthModel?) in
            do {
                let oauthItem = try result.unwrap()
                let filePath = MolueCryption.MD5("182828282828")
                MolueUserLogic.doConnectWithDatabase(path: filePath)
                MolueOauthModel.updateOauthItem(with: oauthItem)
                MolueLogger.network.message(MolueOauthModel.queryOauthItem())
            } catch { MolueLogger.network.message(error) }
        }
        return MolueRequestManager().doRequestStart(with: request ,needOauth: false)
    }
    
    private func queryUserInformation() {
        let request = MolueUserInfoService.queryUserInformation()
        request.handleSuccessResultToObjc { (result: MolueUserInfo?) in
            MolueLogger.network.message(result)
        }
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error.localizedDescription)
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func setDefaultWebImageConfigure() {
        let cache = KingfisherManager.shared.cache
        // 设置硬盘最大缓存50M ，默认无限
        cache.maxDiskCacheSize = 50 * 1024 * 1024
        // 设置硬盘最大保存3天 ， 默认1周
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 3
    }
}

