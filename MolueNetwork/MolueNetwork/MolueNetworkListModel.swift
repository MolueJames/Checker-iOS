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
    
    public func appendMoreResults(with item: MolueListItem<T>?) throws {
        func appendResults(with results: [T]?) throws {
            do {
                let newItems = try results.unwrap()
                var results = try self.results.unwrap()
                results.append(contentsOf: newItems)
                self.results = results
            } catch { throw error }
        }
        
        do {
            let newValue = try item.unwrap()
            try appendResults(with: newValue.results)
        } catch { throw error }
    }
}
