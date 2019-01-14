//
//  MolueUserInfoModel.swift
//  MolueMediator
//
//  Created by JamesCheng on 2018-12-18.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public class MolueUserInfo: Mappable, Codable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        self.setPermissions(with: map)
        enterpriseId <- map["enterprise_id"]
        adminAreaId  <- map["admin_area_id"]
        screenName   <- map["screen_name"]
        dateJoined   <- map["date_joined"]
        lastLogin    <- map["last_login"]
        lastName     <- map["last_name"]
        username     <- map["username"]
        position     <- map["position"]
        profile      <- map["profile"]
        userMobile   <- map["mobile"]
        userOrder    <- map["order"]
        userPhone    <- map["phone"]
        userEmail    <- map["email"]
        nameUser     <- map["name"]
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
    public var nameUser: String?
    public var userOrder: Int?
    public var userPhone: String?
    public var position: String?
    public var profile: String?
    public var userRole: String?
    public var screenName: String?
    public var username: String?
    public var permissions: String?
    
    private func setPermissions(with map: Map) {
        let value: [String]? = map["permissions"].value()
        permissions = value?.joined(separator: ",")
    }
    
    public func getPermissions() -> [String]? {
        do {
            let permissions = try self.permissions.unwrap()
            return permissions.components(separatedBy: ",")
        } catch {
            return MolueLogger.database.allowNil(error)
        }
    }
}
