//
//  MolueHomeProtocols.swift
//  MolueMediator
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public protocol HomeInfoPageInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

public protocol HomeInfoPageComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: HomeInfoPageInteractListener) -> UIViewController
    
    func build() -> UIViewController
}
