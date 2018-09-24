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

open class MolueBuilderFactory: MolueProtocolFactory {
    public typealias Target = MolueBaseBuilder
    
    private let module: MolueModulePath
    open func queryBuilder<T> (fileName: String) -> T? {
        do {
            let className = "\(self.module.rawValue).\(fileName)"
            let targetClass: AnyClass = try NSClassFromString(className).unwrap()
            let targetBuilder = try (targetClass as? Target.Type).unwrap()
            return try targetBuilder.init().toTarget()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    public init(module: MolueModulePath) {
        self.module = module
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

