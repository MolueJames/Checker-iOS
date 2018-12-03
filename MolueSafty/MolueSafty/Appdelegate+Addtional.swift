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
import Kingfisher
import Alamofire

extension AppDelegate {
    func setUserInterfaceConfigure() {
        MLInterfaceConfigure.setInterfaceConfigure()
        self.setDefaultWebImageConfigure()
        self.networkLoginRequest()
    }
    
    private func networkLoginRequest() {
        let headerInfo = Alamofire.Request.authorizationHeader(user: "hj8LAJukEhrs37yPbvXlwX5kG8sk45q0gciIw1Ol", password: "jEOk3ZLDixlJWPyyoncEbcwp4z3Ij5VG05HfKGORg5357CCWeRnrY86OPFpCPF79FaRiUGHnUcb68uCp5NScHg3z5roBqkVY3eB2LHrEaByULCY4JFMRDvXTa7a3ITq9")
        guard let header = headerInfo else {return}
        let xxx = [header.key : header.value]
        let dict = ["username":"13063745829", "password":"q1w2e3r4","grant_type":"password"]

        let request = MolueDataRequest.init(parameter:dict, method: .post, path: "oauth/token/", headers: xxx)
        let manager = MolueRequestManager(request: request)
        manager.handleFailureResponse { (error) in
            print(error.localizedDescription)
            print(error)

        }

        manager.handleSuccessResultToObjc { (result: MolueOauthModel?) in
            print(result)
            print(result?.validateNeedRefresh())
        }
        manager.requestStart()
    }
    
    private func setDefaultWebImageConfigure() {
        let cache = KingfisherManager.shared.cache
        // 设置硬盘最大缓存50M ，默认无限
        cache.maxDiskCacheSize = 50 * 1024 * 1024
        // 设置硬盘最大保存3天 ， 默认1周
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 3
    }
}
