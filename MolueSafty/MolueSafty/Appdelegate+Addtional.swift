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
//        self.networkLoginRequest()
    }
    
    private func networkLoginRequest() {
        let request = MolueOauthService.doLogin(username: "182828282828", password: "-1234Asdf")
        request.handleFailureResponse { (error) in
            MolueLogger.network.message(error.localizedDescription)
        }
        request.handleSuccessResultToObjc { [weak self] (result: MolueOauthModel?) in
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
        request.handleSuccessResultToObjc { (item: MolueListItem<MLDailyPlanDetailModel>?) in
            MolueLogger.network.message(item)
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func queryUserInformation() {
        let request = MolueUserInfoService.queryUserInformation()
        request.handleSuccessResultToObjc { (result: MolueUserInfoModel?) in
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

import ObjectMapper

public class MolueUserInfoModel: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        enterpriseId <- map["enterprise_id"]
        adminAreaId  <- map["admin_area_id"]
        permissions  <- map["permissions"]
        screenName   <- map["screen_name"]
        dateJoined   <- map["date_joined"]
        lastLogin    <- map["last_login"]
        lastName     <- map["last_name"]
        username     <- map["username"]
        position     <- map["position"]
        userMobile   <- map["mobile"]
        userOrder    <- map["order"]
        userPhone    <- map["phone"]
        userEmail    <- map["email"]
        profile      <- map["profile"]
        userName     <- map["name"]
        userRole     <- map["role"]
        userID       <- map["id"]
    }
    
    var adminAreaId: String?
    var dateJoined: String?
    var userEmail: String?
    var enterpriseId: Int?
    var userID: Int?
    var lastLogin: String?
    var lastName: String?
    var userMobile: String?
    var userName: String?
    var userOrder: Int?
    var userPhone: String?
    var position: String?
    var profile: String?
    var userRole: String?
    var screenName: String?
    var username: String?
    var permissions: [Any]?
}
