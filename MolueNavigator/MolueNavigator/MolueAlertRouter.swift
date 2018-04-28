//
//  MolueAlertRouter.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
public class MolueDoAlertRouter {
    private var components = URLComponents()
    
    public enum MolyeAlertStyle :String {
        case sheet = "/sheet"
        case alert = "/alert"
    }
    
    public init(_ style: MolyeAlertStyle, title: String? = nil, message: String? = nil) {
        self.components.scheme = "navigator"
        self.components.host = "alert"
        self.components.path = style.rawValue
        guard let title = title, let message = message else {return}
        self.components.query = QueryUtilities.query(["title": title, "message": message])
    }
    
    public init (_ path: String) {
        self.components.scheme = "navigator"
        self.components.host = "alert"
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        self.components.path = urlPath
    }
    
    public func toPath() -> String? {
        guard self.components.query == nil else {return nil}
        guard let string = self.components.url?.absoluteString else {return nil}
        return string.removingPercentEncoding
    }
    
    public func toString() -> String? {
        guard self.components.query != nil else {return nil}
        guard let string = self.components.url?.absoluteString else {return nil}
        return string.removingPercentEncoding
    }

}
