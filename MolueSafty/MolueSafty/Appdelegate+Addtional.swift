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

extension AppDelegate {
    func setUserInterfaceConfigure() {
        MLInterfaceConfigure.setInterfaceConfigure()
        self.setDefaultWebImageConfigure()
    }
    
    private func setDefaultWebImageConfigure() {
        let cache = KingfisherManager.shared.cache
        // 设置硬盘最大缓存50M ，默认无限
        cache.maxDiskCacheSize = 50 * 1024 * 1024
        // 设置硬盘最大保存3天 ， 默认1周
        cache.maxCachePeriodInSecond = 60 * 60 * 24 * 3
    }
}

