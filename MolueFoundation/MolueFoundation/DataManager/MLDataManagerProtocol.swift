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
        objc_sync_enter(self); defer{objc_sync_exit(self)}
        self.items.remove(at: index)
    }
    func item<Target>(at index: Int) -> Target {
        do {
            objc_sync_enter(self); defer{objc_sync_exit(self)}
            return try (self.items[index] as? Target).unwrap()
        } catch {
            fatalError("the item is not Target")
        }
    }
    mutating func replace<Target>(index: Int, new: Target) {
        do {
            objc_sync_enter(self); defer{objc_sync_exit(self)}
            let newValue = try (new as? Self.ItemTarget).unwrap()
            self.items[index] = newValue
        } catch {
            fatalError("the new is not ItemTarget")
        }
    }
    mutating func append<Target>(item: Target) {
        do {
            objc_sync_enter(self); defer{objc_sync_exit(self)}
            let newItem = try (item as? Self.ItemTarget).unwrap()
            self.items.append(newItem)
        } catch {
            fatalError("the new is not ItemTarget")
        }
    }
    mutating func append<Target>(items: [Target]) {
        do {
            objc_sync_enter(self); defer{objc_sync_exit(self)}
            let newItems = try (items as? [Self.ItemTarget]).unwrap()
            self.items.append(contentsOf:newItems)
        } catch {
            fatalError("the new is not ItemTarget")
        }
    }
    func count() -> Int {
        return self.items.count
    }
}
