//
//  TargetTypeExtension.swift
//  MolueUtilities
//
//  Created by MolueJames on 2018/9/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
public func validateTarget<T>(_ value: Any?, file: String = #file, function: String = #function, line: Int = #line) throws -> T {
    guard let value = value as? T else { throw MolueNilError(file: file, function: function, line: line) }
    return value
}

public protocol MolueTargetHelper {}

public extension MolueTargetHelper where Self: Any {
    public func toTarget<T> (file: String = #file, function: String = #function, line: Int = #line) throws -> T {
        guard let value = self as? T else { throw MolueNilError(file: file, function: function, line: line) }
        return value
    }
}

extension NSObject: MolueTargetHelper {}
extension CGPoint: MolueTargetHelper {}
extension CGRect: MolueTargetHelper {}
extension CGSize: MolueTargetHelper {}
extension CGVector: MolueTargetHelper {}
extension Array: MolueTargetHelper {}
extension Dictionary: MolueTargetHelper{}
extension String: MolueTargetHelper{}
