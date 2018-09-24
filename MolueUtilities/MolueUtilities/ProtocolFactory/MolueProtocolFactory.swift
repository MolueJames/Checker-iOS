//
//  MolueProtocolFactory.swift
//  MolueUtilities
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public enum MolueModulePath: String {
    case Mine = "MolueMinePart"
    case Home = "MolueHomePart"
    case Risk = "MolueRiskPart"
    case Book = "MolueBookPart"
    case Common = "MolueCommon"
    case Login = "MolueLoginPart"
}

public protocol MolueProtocolFactory: class {
    associatedtype Target
    func queryBuilder<T> (fileName:String) -> T?
}
