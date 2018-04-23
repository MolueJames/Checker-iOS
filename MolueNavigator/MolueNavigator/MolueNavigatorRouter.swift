//
//  MolueRouterComponents.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public class MolueNavigatorRouter {
    var components = URLComponents()
    
    enum RouterHost: String {
        case Mine = "MolueMinePart"
        case Home = "MolueHomePart"
    }
    
    init(_ host: RouterHost, path: String) {
        self.components.scheme = "navigator"
        self.components.host = host.rawValue
        let urlPath = path.hasPrefix("/") ? path : "/" + path
        if let path =  urlPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed){
            self.components.percentEncodedPath = path
        }
    }
    
    func toString() -> String? {
        if let string = self.components.url?.absoluteString {
            return string.removingPercentEncoding
        }
        return nil
    }
}



