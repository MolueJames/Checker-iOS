//
//  MLDataManagerProtocol.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/6/21.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MLDataManagerProtocol: class {
    associatedtype DataManagerTarget
    var dataManager: DataManagerTarget {get set}
}

public protocol MLListManagerProtocol {
    
    associatedtype Item
    
    var items: [Item] {get set}
    
    func count() -> Int
    
    mutating func append(item: Item)
    
    mutating func append(newItems: [Item])
    
    mutating func remove(at index: Int)
    
    func item(at index: Int) -> Item
}

public extension MLListManagerProtocol {
    func count() -> Int {
        return items.count
    }
    
    mutating func append(item: Item) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.append(item)
    }
    
    mutating func append(newItems: [Item]) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.append(contentsOf: newItems)
    }
    
    mutating func remove(at index: Int) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items.remove(at: index)
    }
    
    func item(at index: Int) -> Item {
        return items[index]
    }
    
    mutating func replace(index: Int, new: Item) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        items[index] = new
    }
}
