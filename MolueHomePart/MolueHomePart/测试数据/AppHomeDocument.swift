//
//  AppHomeDocument.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/25.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation
import MolueMediator
private let single = AppHomeDocument()
class AppHomeDocument {
    public class var shared: AppHomeDocument {
        return single
    }
    lazy var unitList: [DangerUnitSectionHeaderModel] = {
        let list = [DangerUnitSectionHeaderModel]()
        
        return list
    }()
    
    func addDangerUnitModel(to list: inout [DangerUnitSectionHeaderModel]) {
        var model1 = DangerUnitSectionHeaderModel()
        model1.unitName = ""
        model1.unitClass = ""
        model1.unitNumber = ""
        model1.unitRisks = [DangerUnitRiskModel]()
        var item11 = DangerUnitRiskModel()
        item11.riskName? = ""
        var item12 = DangerUnitRiskModel()
        item12.riskName? = ""
        var item13 = DangerUnitRiskModel()
        item13.riskName? = ""
        model1.unitRisks?.append(item11)
        model1.unitRisks?.append(item12)
        model1.unitRisks?.append(item13)
        list.append(model1)
    }
}
