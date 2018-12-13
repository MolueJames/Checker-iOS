//
//  MolueResultListModel.swift
//  MolueNetwork
//
//  Created by MolueJames on 2018/12/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper
public class MolueListModel<T: Mappable>: Mappable {
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        previous <- map["previous"]
        results  <- map["results"]
        count    <- map["count"]
        next     <- map["next"]
    }
    
    var count: Int?
    var next: String?
    var previous: String?
    var results: [T]?
}
