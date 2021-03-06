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
}

public protocol QuickCheckRiskInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol QuickCheckRiskComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: QuickCheckRiskInteractListener) -> UIViewController
    
    func build() -> UIViewController
}

public protocol EditRiskInfoInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var detailRisk: MLRiskPointDetail? { get }
    var attachment: MLTaskAttachment? { get }
    
    func removeSelectedItemAtIndexPath()
}

public protocol EditRiskInfoComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: EditRiskInfoInteractListener) -> UIViewController
}

public protocol RiskDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var hiddenPeril: MLHiddenPerilItem? { get }
}

public protocol RiskDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskDetailInteractListener) -> UIViewController
}

public protocol RiskFollowInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol RiskFollowComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskFollowInteractListener) -> UIViewController
}
