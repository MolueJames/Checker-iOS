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

import MolueHomePart

extension AppDelegate {
    func setUserInterfaceConfigure() {
        MLInterfaceConfigure.setInterfaceConfigure()
        self.setDefaultWebImageConfigure()
        self.queryDailyPlanList()
    }
    
    private func networkLoginRequest() {
        let request = MolueOauthService.doLogin(username: "182828282828", password: "-1234Asdf")
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error.localizedDescription)
        }
        request.handleSuccessResultToObjc { [weak self] (result: MolueOauthModel?) in
            dump(result)
            do {
                let oauthItem = try result.unwrap()
                MolueOauthModel.updateOauthItem(with: oauthItem)
                MolueLogger.database.message(MolueOauthModel.queryOauthItem())
                try self.unwrap().queryDailyPlanList()
            } catch { MolueLogger.network.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request ,needOauth: false)
    }
    
    private func queryDailyPlanList() {
        let request = MolueCheckService.queryDailyPlanList(page: 1, pagesize: 2)
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error.localizedDescription)
        }
        request.handleSuccessResultToObjc { (item: MolueListModel<MLDailyPlanDetailModel>?) in
            dump(item)
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
