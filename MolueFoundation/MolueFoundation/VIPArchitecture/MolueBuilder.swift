//
//  MolueBuilder.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
public protocol MolueBuildable: class {}

open class MolueBaseBuilder: MolueBuildable {
    public required init() {}
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

extension MolueBaseBuilder: MolueTargetHelper {}
