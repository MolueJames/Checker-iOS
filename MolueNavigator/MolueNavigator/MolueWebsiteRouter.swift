//
//  MolueWebsiteRouter.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
public class MolueWebsiteRouter {
    private var components = URLComponents()
    var scheme: String?
    var path: String?
    
    enum RouterScheme: String {
        case HTTP  = "http"
        case HTTPS = "https"
    }
    
    init(_ scheme: RouterScheme, url: String) {
        self.scheme = scheme.rawValue
        guard let components = URLComponents(string: url) else {
            MolueLogger.failure.error("the commponents is not existed"); return
        }
        self.components = components
    }
    init(url: String) {
        guard let components = URLComponents(string: url) else {
            MolueLogger.failure.error("the commponents is not existed"); return
        }
        guard let scheme = components.scheme else {
            MolueLogger.failure.error("the scheme is not existed"); return
        }
        self.components = components
        self.scheme = scheme
    }
    
    init(_ scheme: RouterScheme, path: String) {
        self.components = URLComponents()
        self.scheme = scheme.rawValue
        self.path = path
        self.components.scheme = self.scheme
        self.components.path = path
    }
    
    public func toString() -> String? {
        guard self.scheme == self.components.scheme else {
            return MolueLogger.failure.returnNil("the schme is not existed")
        }
        guard let url = self.components.url else {
            return MolueLogger.failure.returnNil("the url is not existed")
        }
        guard url.absoluteString.isEmpty else {
            return url.absoluteString
        }
        return MolueLogger.failure.returnNil("the url string is empty")
    }
    
    func toPath() -> String? {
        guard let scheme = self.scheme, let path = self.path else {
            return MolueLogger.failure.returnNil("the schme or path is not existed")
        }
        return scheme + "://" + path
    }
}
