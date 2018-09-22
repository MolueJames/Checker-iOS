//
//  MolueBuilderFactory.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation
import MolueFoundation
import MolueUtilities
import MolueCommon

public class MolueBuilderFactory: MolueProtocolFactory {
    public typealias Target = MolueBaseBuilder
    
    public func queryBuilder<T> (module: MolueModulePath, fileName:String) -> T? {
        do {
            let className = "\(module.rawValue).\(fileName)"
            let targetClass: AnyClass = try NSClassFromString(className).unwrap()
            let targetBuilder = try (targetClass as? Target.Type).unwrap()
            return try targetBuilder.init().toTarget()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
}
