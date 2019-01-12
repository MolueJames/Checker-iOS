//
//  MolueResultListModel.swift
//  MolueNetwork
//
//  Created by MolueJames on 2018/12/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
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
    
    public init(_ pagesize: Int = 10) {
        self.pagesize = pagesize
    }
    
    public var pagesize: Int = 0
    public var count: Int?
    public var next: Int?
    public var previous: Int?
    public var results: [T]?
    
    public func append(with item: MolueListItem<T>?) throws {
        do {
            let newItem = try item.unwrap()
            let results = try newItem.results.unwrap()
            self.results?.append(contentsOf: results)
            self.next = newItem.next
        } catch { throw error }
    }
    
    public func replace(with result: T, index: Int) {
        self.results?[index] = result
    }
}
