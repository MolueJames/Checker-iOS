//
//  MolueUserInfoModel.swift
//  MolueMediator
//
//  Created by JamesCheng on 2018-12-18.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
import ObjectMapper

public class MolueUserInfo: Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        enterpriseId <- map["enterprise_id"]
        adminAreaId  <- map["admin_area_id"]
        permissions  <- map["permissions"]
        screenName   <- map["screen_name"]
        dateJoined   <- map["date_joined"]
        lastLogin    <- map["last_login"]
        lastName     <- map["last_name"]
        username     <- map["username"]
        position     <- map["position"]
        userMobile   <- map["mobile"]
        userOrder    <- map["order"]
        userPhone    <- map["phone"]
        userEmail    <- map["email"]
        profile      <- map["profile"]
        userName     <- map["name"]
        userRole     <- map["role"]
        userID       <- map["id"]
    }
    
    public var adminAreaId: String?
    public var dateJoined: String?
    public var userEmail: String?
    public var enterpriseId: Int?
    public var userID: Int?
    public var lastLogin: String?
    public var lastName: String?
    public var userMobile: String?
    public var userName: String?
    public var userOrder: Int?
    public var userPhone: String?
    public var position: String?
    public var profile: String?
    public var userRole: String?
    public var screenName: String?
    public var username: String?
    public var permissions: [String]?
}
