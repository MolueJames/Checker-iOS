//
//  MLDataManagerProtocol.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/6/21.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MLListDataHelperProtocol {
    
    associatedtype ItemTarget
    
    var items: [ItemTarget] {get set}
    
    func count() -> Int
    
    mutating func append(item: ItemTarget)
    
    mutating func append(newItems: [ItemTarget])
    
    mutating func remove(at index: Int)
    
    func item(at index: Int) -> ItemTarget
}

public extension MLListDataHelperProtocol {
    func count() -> Int {
        return items.count
    }
    
    mutating func append(item: ItemTarget) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.append(item)
    }
    
    mutating func append(newItems: [ItemTarget]) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.append(contentsOf: newItems)
    }
    
    mutating func remove(at index: Int) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.remove(at: index)
    }
    
    func item(at index: Int) -> ItemTarget {
        return items[index]
    }
    
    mutating func replace(index: Int, new: ItemTarget) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items[index] = new
    }
}
