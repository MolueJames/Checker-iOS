//
//  MolueLoginProtocols.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/9/24.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation
import MolueUtilities
import ObjectMapper

public protocol UserLoginPageInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol UserLoginPageComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: UserLoginPageInteractListener) -> UIViewController
    
    func build() -> UIViewController
}
