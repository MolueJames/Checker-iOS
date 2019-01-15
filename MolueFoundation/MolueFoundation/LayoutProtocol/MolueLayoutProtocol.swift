//
//  MolueLayoutProtocol.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public protocol MolueControllerLayout where Self: MLBaseViewController {
    func doControllerLayout()
}

public protocol MolueViewElementLayout where Self: UIView {
    func doViewElementLayout()
}
