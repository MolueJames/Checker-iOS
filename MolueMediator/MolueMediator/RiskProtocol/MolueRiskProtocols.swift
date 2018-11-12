//
//  MolueDangerProtocol.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public protocol PotentialRiskInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol PotentialRiskComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: PotentialRiskInteractListener) -> UIViewController
    //定义当前的Component的构造方法.
    func build() -> UIViewController
}

public protocol QuickCheckRiskInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol QuickCheckRiskComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: QuickCheckRiskInteractListener) -> UIViewController
    
    func build() -> UIViewController
}
