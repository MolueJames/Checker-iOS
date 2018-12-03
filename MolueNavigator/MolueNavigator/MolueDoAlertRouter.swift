//
//  MolueAlertRouter.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
public class MolueDoAlertRouter {
    private var components = URLComponents()
    
    public init(_ style: UIAlertController.Style, title: String? = nil, message: String? = nil) {
        do {
            self.components.scheme = "navigator"
            self.components.host = "alert"
            self.components.path = style.toString()
            let title = try title.unwrap()
            let message = try message.unwrap()
            self.components.query = QueryUtilities.query(["title": title, "message": message])
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    public init (_ path: String) {
        self.components.scheme = "navigator"
        self.components.host = "alert"
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        self.components.path = urlPath
    }
    
    public func toPath() -> String? {
        do {
            let url = try self.components.url.unwrap()
            let absolute = try url.absoluteString.removingPercentEncoding.unwrap()
            return absolute
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    public func toString() -> String? {
        do {
            let url = try self.components.url.unwrap()
            let absolute = try url.absoluteString.removingPercentEncoding.unwrap()
            return absolute
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
}

fileprivate extension UIAlertController.Style {
    fileprivate func toString() -> String {
        switch self {
        case .alert:
            return "/alert"
        case .actionSheet:
            return "/sheet"
        }
    }
}
