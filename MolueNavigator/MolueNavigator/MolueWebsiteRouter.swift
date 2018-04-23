//
//  MolueWebsiteRouter.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public class MolueWebsiteRouter {
    var components: URLComponents?
    var scheme: String?
    
    enum RouterScheme: String {
        case HTTP = "http"
        case HTTPS = "https"
    }
    
    init(_ scheme: RouterScheme, url: String) {
        self.components = URLComponents(string: url)
        if var components = self.components {
            guard let tempScheme = components.scheme else {
                components.scheme = scheme.rawValue
                return
            }
            if tempScheme != scheme.rawValue {
                self.components = nil
            }
        }
    }
    
    init(_ scheme: RouterScheme, path: String) {
        var tempComponents = URLComponents()
        tempComponents.scheme = scheme.rawValue
        var urlPath = path
        if urlPath.hasPrefix("/") {
            urlPath.remove(at: urlPath.startIndex)
        }
        if let path =  urlPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed){
            tempComponents.percentEncodedPath = path
        }
        self.components = tempComponents
    }
    
    func toString() -> String? {
        guard let components = self.components else { return nil }
        guard let scheme = components.scheme else { return nil }
        
        if let path = components.path.removingPercentEncoding {
            return scheme + "://" + path
        } else if let url = components.url {
            return url.absoluteString
        } else {
            return nil
        }
    }
}
