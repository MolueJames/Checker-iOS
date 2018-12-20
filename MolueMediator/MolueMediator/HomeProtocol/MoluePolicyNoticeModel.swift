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
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        noticeId <- map["id"]
        notification <- map["notification"]
        enterprise <- map["enterprise"]
        signatureUser <- map["signature_user"]
        readUser <- map["read_user"]
        signatureTime <- map["signature_time"]
        readTime <- map["read_time"]
    }
    
    public var noticeId: Int?
    public var notification: MoluePolicyNotification?
    public var enterprise: Int?
    public var signatureUser: String?
    public var readUser: String?
    public var signatureTime: String?
    public var readTime: String?
    
}

public class MoluePolicyNotification: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        createUser <- map["create_user"]
        published <- map["date_published"]
        needSignature <- map["need_signature"]
        notificationId <- map["id"]
        content <- map["content"]
        title <- map["title"]
        type <- map["type"]
    }
    
    public var createUser: String?
    public var published: String?
    public var needSignature: Bool?
    public var notificationId: Int?
    public var content: String?
    public var title: String?
    public var type: String?
}
