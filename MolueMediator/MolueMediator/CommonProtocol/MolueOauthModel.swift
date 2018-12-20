//
//  MolueOauthModel.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public struct MolueOauthModel: Mappable, Codable {

    public mutating func mapping(map: Map) {
        access_token   <- map["access_token"]
        refresh_token  <- map["refresh_token"]
        scope          <- map["scope"]
        token_type     <- map["token_type"]
        let expires_in: Double? = map["expires_in"].value()
        self.setExpires_data(expires_in: expires_in)
    }
    
    private mutating func setExpires_data(expires_in: Double?) {
        do {
            let expires_in = try expires_in.unwrap() - 35980
            let date = Date().addingTimeInterval(expires_in)
            expires_date = date.string(withFormat: "yyyy/MM/dd HH:mm:ss")
        } catch { MolueLogger.network.error(error) }
    }
    
    public init?(map: Map) {}
    
    public var access_token: String?
    public var expires_date: String?
    public var refresh_token: String?
    public var scope: String?
    public var token_type: String?
    
    public func validateNeedRefresh() -> Bool {
        do {
            let expiresDate = try self.expires_date.unwrap()
            let expires_date = expiresDate.date(withFormat: "yyyy/MM/dd HH:mm:ss")
            return try !expires_date.unwrap().isInFuture
        } catch { return true }
    }
}

