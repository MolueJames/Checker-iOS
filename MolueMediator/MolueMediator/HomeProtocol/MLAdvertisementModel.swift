//
//  MLAdvertisementItem.swift
//  MolueMediator
//
//  Created by JamesCheng on 2019-01-14.
//  Copyright © 2019 MolueJames. All rights reserved.
//

import Foundation
import ObjectMapper

public class MLAdvertisement: Mappable {
    public required init?(map: Map) {
        viewCount <- map["view_count"]
        cityCode <- map["city_code"]
        provCode <- map["prov_code"]
        platform <- map["platform"]
        position <- map["position"]
        description <- map["desc"]
        content <- map["content"]
        created <- map["created"]
        updated <- map["updated"]
        advertiseId <- map["id"]
        status <- map["status"]
    }
    
    public func mapping(map: Map) {
        
    }
    public var content: MLAdvertiseContent?
    public var advertiseId: String?
    public var description: String?
    public var platform: String?
    public var cityCode: String?
    public var provCode: String?
    public var position: String?
    public var created: String?
    public var updated: String?
    public var status: String?
    public var viewCount: Int?
}

public class MLAdvertiseContent: Mappable {
    public required init?(map: Map) {
        attribute <- map["action_attr"]
        imageUrl <- map["image_url"]
        value <- map["action_value"]
        action <- map["action"]
        title <- map["title"]
        type <- map["type"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var attribute: String?
    public var imageUrl: String?
    public var action: String?
    public var title: String?
    public var value: String?
    public var type: String?
}
