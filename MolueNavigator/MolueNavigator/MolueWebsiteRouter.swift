//
//  MolueWebsiteRouter.swift
//  MolueNavigator
//
//  Created by James on 2018/4/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public class MolueWebsiteRouter {
    private var components = URLComponents()
    var scheme: String?
    var path: String?
    
    enum RouterScheme: String {
        case HTTP = "http"
        case HTTPS = "https"
    }
    
    init(_ scheme: RouterScheme, url: String) {
        self.scheme = scheme.rawValue
        guard let components = URLComponents(string: url) else {return}
        self.components = components
    }
    init(url: String) {
        guard let components = URLComponents(string: url) else {return}
        guard let scheme = components.scheme else {return}
        self.components = components
        self.scheme = scheme
    }
    
    init(_ scheme: RouterScheme, path: String) {
        self.scheme = scheme.rawValue
        self.path = path
    }
    
    public func toString() -> String? {
        guard self.scheme == self.components.scheme else {return nil}
        guard let url = self.components.url else {return nil}
        return url.absoluteString.isEmpty ? nil : url.absoluteString
    }
    
    func toPath() -> String? {
        guard let scheme = self.scheme, let path = self.path else {return nil}
        return scheme + "://" + path
    }
}
