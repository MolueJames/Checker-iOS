//
//  MolueCommonColor.swift
//  MolueCommon
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
public class CommonColor {}

extension CommonColor: HomePartCompatible {
    
}

extension MolueKit where Base == CommonColor {
    public static let red = UIColor.red
}

extension CommonColor: MinePartCompatible {
    
}

extension MolueKit where Base == CommonColor {
    
}
