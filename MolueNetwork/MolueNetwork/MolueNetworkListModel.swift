//
//  MolueResultListModel.swift
//  MolueNetwork
//
//  Created by MolueJames on 2018/12/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper
public class MolueListItem<T: Mappable>: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        pagesize <- map["page_size"]
        previous <- map["previous"]
        results  <- map["results"]
        count    <- map["count"]
        next     <- map["next"]
    }
    
    public var count: Int?
    public var next: Int?
    public var pagesize: Int?
    public var previous: Int?
    public var results: [T]?
}
