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
        actionValue <- map["action_value"]
        actionAttr <- map["action_attr"]
        viewCount <- map["view_count"]
        imageUrl <- map["image_url"]
        position <- map["position"]
        platform <- map["platform"]
        updated <- map["updated"]
        created <- map["created"]
        status <- map["status"]
        action <- map["action"]
        title <- map["title"]
        itemId <- map["id"]
    }
    
    public func mapping(map: Map) {
        
    }
    
    public var actionValue: String?
    public var actionAttr: String?
    public var imageUrl: String?
    public var position: String?
    public var platform: String?
    public var updated: String?
    public var created: String?
    public var action: String?
    public var itemId: String?
    public var viewCount: Int?
    public var status: String?
    public var title: String?
}
