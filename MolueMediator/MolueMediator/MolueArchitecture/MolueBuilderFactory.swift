//
//  MolueBuilderFactory.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities

open class MolueBuilderFactory<Component: MolueBuilderPathProtocol> {
    
    private let component: Component
    
    open func queryBuilder<T> () -> T? {
        do {
            let className = component.builderPath()
            let targetClass: AnyClass = try NSClassFromString(className).unwrap()
            let targetBuilder = try (targetClass as? MolueComponentBuilder.Type).unwrap()
            return try targetBuilder.init().toTarget()
        } catch {
            return MolueLogger.failure.returnNil(error)
        }
    }
    
    public init(_ component: Component) {
        self.component = component;
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

