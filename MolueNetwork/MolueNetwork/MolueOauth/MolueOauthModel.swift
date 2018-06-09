//
//  MolueOauthModel.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Locksmith
import ObjectMapper
import MolueUtilities

public struct MolueOauthModel: Mappable, ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {
    public mutating func mapping(map: Map) {
        access_token   <- map["access_token"]
        expires_in     <- map["expires_in"]
        refresh_token  <- map["refresh_token"]
        scope          <- map["scope"]
        token_type     <- map["token_type"]
        self.setExpires_data(expires_in: expires_in)
    }
    
    private mutating func setExpires_data(expires_in: Double?) {
        guard let expires_in = expires_in else {
            MolueLogger.failure.error("expires in is nil"); return
        }
        expires_date = Date().addingTimeInterval(expires_in)
    }
    
    public init?(map: Map) {
    
    }
    
    public var service: String = ""
    
    public var account: String = "MolueOauthKey"
    
    public var data: [String : Any] {
        return ["access_token": access_token ?? ""]
    }
    
    public var access_token: String?
    public var expires_in: Double?
    public var expires_date: Date?
    public var refresh_token: String?
    public var scope: String?
    public var token_type: String?
    
    public func validateNeedRefresh() -> Bool {
        guard let expires_date = self.expires_date else {
            MolueLogger.failure.error("the expires data is nil")
            return false
        }
        return expires_date.isInFuture
    }
}
