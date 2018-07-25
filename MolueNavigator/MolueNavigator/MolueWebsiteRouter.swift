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
        do {
            self.scheme = scheme.rawValue
            let commponents = try URLComponents(string: url).unwrap()
            self.components = commponents
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    init(url: String) {
        do {
            self.components = try URLComponents(string: url).unwrap()
            self.scheme = try components.scheme.unwrap()
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    init(_ scheme: RouterScheme, path: String) {
        self.components = URLComponents()
        self.scheme = scheme.rawValue
        self.path = path
        self.components.scheme = self.scheme
        self.components.path = path
    }
    
    public func toString() -> String? {
        do {
            self.scheme = try self.components.scheme.unwrap()
            let url = try self.components.url.unwrap()
            guard url.absoluteString.isEmpty else {return url.absoluteString}
            return MolueLogger.failure.returnNil("the url string is empty")
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    func toPath() -> String? {
        do {
            let scheme = try self.scheme.unwrap()
            let path = try self.path.unwrap()
            return scheme + "://" + path
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
}
