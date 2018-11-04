//
//  MolueMineProtocols.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public protocol UserInfoCenterInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol UserInfoCenterComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: UserInfoCenterInteractListener) -> UIViewController
    
    func build() -> UIViewController
}
