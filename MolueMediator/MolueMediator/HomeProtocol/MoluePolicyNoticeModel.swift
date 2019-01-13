//
//  MoluePolicyNoticeModel.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper

public class MLPolicyNoticeModel: Mappable {
    public required init?(map: Map) {
        noticeId <- map["id"]
        notification <- map["notification"]
        enterpriseId <- map["enterprise_id"]
        signatureUser <- map["signature_user"]
        readUser <- map["read_user"]
        signatureTime <- map["signature_time"]
        readTime <- map["read_time"]
        readed <- map["read"]
        signed <- map["signed"]
        status <- map["status"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var noticeId: Int?
    public var notification: MoluePolicyNotification?
    public var enterpriseId: Int?
    public var signatureUser: MolueUserInfo?
    public var readUser: MolueUserInfo?
    public var signatureTime: String?
    public var readTime: String?
    public var readed: Bool?
    public var signed: Bool?
    public var status: String?
}

public class MoluePolicyNotification: Mappable {
    public required init?(map: Map) {
        createUser <- map["create_user"]
        published <- map["date_published"]
        needSignature <- map["need_signature"]
        notificationId <- map["id"]
        content <- map["content"]
        title <- map["title"]
        type <- map["type"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var createUser: MolueUserInfo?
    public var published: String?
    public var needSignature: Bool?
    public var notificationId: Int?
    public var content: String?
    public var title: String?
    public var type: String?
}
