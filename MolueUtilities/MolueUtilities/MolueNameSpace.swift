//
//  Molue_NameSpace.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public final class MolueKit<Base> {
    public let base: Base
    
    public init(base: Base) {
        self.base = base
    }
}

public protocol MolueKitCompatible {
    associatedtype compatibleType
    var ml: compatibleType { get }
    static var ml: compatibleType.Type { get }
}

public extension MolueKitCompatible {
    public var ml: MolueKit<Self> {
        get { return MolueKit(base: self)}
    }
    public static var ml: MolueKit<Self>.Type {
        get { return MolueKit<Self>.self}
    }
}

extension String: MolueKitCompatible {
    
}

extension MolueKit where Base == String {
    
}
