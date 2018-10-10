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

public protocol MolueLoginPageBuildable: MolueComponentBuildable {
    func build(listener: MolueLoginPageInteractable) -> UIViewController?
}

public protocol MolueLoginPageInteractable: class {
    func testFunction()
}
