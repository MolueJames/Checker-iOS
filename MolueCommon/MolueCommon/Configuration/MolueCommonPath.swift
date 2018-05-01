//
//  MolueController.swift
//  MolueCommon
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
public class FilePath {}

extension FilePath: HomePartCompatible {
    
}

extension MolueKit where Base == FilePath {
    public static let HomeInfor = "HomeInforViewController"
}

extension FilePath: MinePartCompatible {
    
}

extension MolueKit where Base == FilePath {
    public static let MineInfor = "MineInforViewController"
}
