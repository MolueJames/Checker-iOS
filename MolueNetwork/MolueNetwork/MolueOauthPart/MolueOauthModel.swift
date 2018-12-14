//
//  MolueOauthModel.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper
import MolueUtilities
import KeychainAccess

private let keychainSevice: String = "com.safety-saas.api-token"

public struct MolueOauthModel: Mappable {
    
    public mutating func mapping(map: Map) {
        access_token   <- map["access_token"]
        expires_in     <- map["expires_in"]
        refresh_token  <- map["refresh_token"]
        scope          <- map["scope"]
        token_type     <- map["token_type"]
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
    
    private init() {}
    
    public var access_token: String?
    public var expires_in: Double?
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
    
    private static var OauthItem: MolueOauthModel?
    
    public static func updateOauthItem(with newValue: MolueOauthModel?) {
        MolueOauthModel.OauthItem = newValue
        MolueOauthModel.updateKeyChain(with: newValue)
    }
    
    public static func queryOauthItem() -> MolueOauthModel? {
        if MolueOauthModel.OauthItem.isSome() {
            return MolueOauthModel.OauthItem
        } else {
            return self.queryFromKeyChain()
        }
    }
}

extension MolueOauthModel {
    private static func updateKeyChain(with newValue: MolueOauthModel?) {
        let keychain = Keychain(service: keychainSevice)
        keychain["refresh_token"] = newValue?.refresh_token
        keychain["access_token"] = newValue?.access_token
        keychain["expires_date"] = newValue?.expires_date
        keychain["token_type"] = newValue?.token_type
        keychain["scope"] = newValue?.scope
    }
    
    private static func queryFromKeyChain() -> MolueOauthModel? {
        do {
            let keychain = Keychain(service: keychainSevice)
            var result: [String : String] = [String : String]()
            result["refresh_token"] = try keychain["refresh_token"].unwrap()
            result["access_token"] = try keychain["access_token"].unwrap()
            result["expires_date"] = try keychain["expires_date"].unwrap()
            result["token_type"] = try keychain["token_type"].unwrap()
            result["scope"] = try keychain["scope"].unwrap()
            return Mapper<MolueOauthModel>().map(JSONObject: result)
        } catch {
            return MolueLogger.network.allowNil(error)
        }
        
    }
}
