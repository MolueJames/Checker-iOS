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
    var molue: compatibleType { get }
    static var molue: compatibleType.Type { get }
}

public extension MolueKitCompatible {
    public var molue: MolueKit<Self> {
        get { return MolueKit(base: self)}
    }
    public static var molue: MolueKit<Self>.Type {
        get { return MolueKit<Self>.self}
    }
}

public protocol HomePartCompatible {
    associatedtype compatibleType
    var home: compatibleType { get }
    static var home: compatibleType.Type { get }
}

public extension HomePartCompatible {
    public var home: MolueKit<Self> {
        get { return MolueKit(base: self)}
    }
    public static var home: MolueKit<Self>.Type {
        get { return MolueKit<Self>.self}
    }
}

public protocol MinePartCompatible {
    associatedtype compatibleType
    var mine: compatibleType { get }
    static var mine: compatibleType.Type { get }
}

public extension MinePartCompatible {
    public var mine: MolueKit<Self> {
        get { return MolueKit(base: self)}
    }
    public static var mine: MolueKit<Self>.Type {
        get { return MolueKit<Self>.self}
    }
}
