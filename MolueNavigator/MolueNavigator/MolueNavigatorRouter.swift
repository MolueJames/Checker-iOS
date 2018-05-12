//
//  MolueRouterComponents.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public class MolueNavigatorRouter {
    private var components = URLComponents()
    
    public enum RouterHost: String {
        case Mine = "MolueMinePart"
        case Home = "MolueHomePart"
        case Base = "MolueFoundation"
    }
    
    public init(_ host: RouterHost, path: String, query: String? = nil) {
        self.components.scheme = "navigator"
        self.components.host = host.rawValue
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        self.components.path = urlPath
        self.components.query = query
    }
    
    public func toString() -> String? {
        if let string = self.components.url?.absoluteString {
            return string.removingPercentEncoding
        }
        return nil
    }
}



