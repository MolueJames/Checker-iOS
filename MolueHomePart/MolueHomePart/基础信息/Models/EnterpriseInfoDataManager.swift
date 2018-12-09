//
//  EnterpriseInfoDataManager.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/6/21.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueFoundation

public struct EnterpriseInfoDataManager: MLNeedListDataProtocol, EnterpriseInfoDataProtocol {

    public typealias ItemTarget = EnterpriseInfoModel
    
    public var items: [EnterpriseInfoModel] = EnterpriseInfoModel.defaultValues()!
}
