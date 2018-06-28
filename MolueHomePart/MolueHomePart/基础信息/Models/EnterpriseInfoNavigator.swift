//
//  EnterpriseInfoNavigator.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/6/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNavigator

public struct EnterpriseInfoNavigator: EnterpriseInfoNavigatorProtocol {
    func pushToController(path: String) {
        let target = MolueNavigatorRouter(.Home, path: path)
        router?.push(target)
    }
}
