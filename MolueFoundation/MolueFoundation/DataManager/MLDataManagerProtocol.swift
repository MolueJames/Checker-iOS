//
//  MLDataManagerProtocol.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/6/21.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MLNeedListDataProtocol {
    
    associatedtype ItemTarget
    
    var items: [ItemTarget] {get set}
}

public protocol MLDataManagerProtocol {}

public protocol MLListDataManagerProtocol: MLDataManagerProtocol {
    func count() -> Int
    
    mutating func append<Target>(item: Target)
    
    mutating func append<Target>(items: [Target])
    
    mutating func remove(at index: Int)
    
    func item<Target>(at index: Int) -> Target
    
    mutating func replace<Target>(index: Int, new: Target)
}

public extension MLListDataManagerProtocol where Self: MLNeedListDataProtocol {
    mutating func remove(at index: Int) {
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        self.items.remove(at: index)
    }
    func item<Target>(at index: Int) -> Target {
        objc_sync_enter(self); defer{objc_sync_exit(self)}
        guard let item = self.items[index] as? Target else {
            fatalError("the item is not Target")
        }
        return item
    }
    mutating func replace<Target>(index: Int, new: Target) {
        objc_sync_enter(self); defer{objc_sync_exit(self)}
        guard let newValue = new as? Self.ItemTarget else {
            fatalError("the new is not ItemTarget")
        }
        self.items[index] = newValue
    }
    mutating func append<Target>(item: Target) {
        objc_sync_enter(self); defer{objc_sync_exit(self)}
        guard let newItem = item as? Self.ItemTarget else {
            fatalError("the item is not ItemTarget")
        }
        self.items.append(newItem)
    }
    mutating func append<Target>(items: [Target]) {
        objc_sync_enter(self); defer{objc_sync_exit(self)}
        guard let newItems = items as? [Self.ItemTarget] else {
            fatalError("the items is not [ItemTarget]")
        }
        self.items.append(contentsOf:newItems)
    }
    func count() -> Int {
        return self.items.count
    }
}
