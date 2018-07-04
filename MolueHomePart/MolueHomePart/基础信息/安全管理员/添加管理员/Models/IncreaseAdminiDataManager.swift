//
//  IncreaseAdminiDataManager.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/7/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueCommon
struct IncreaseAdminiDataManager: IncreaseAdminiDataProtocol {
    
    var fullTimeList: [MLSelectedTableViewModel] {
        let model1 = MLSelectedTableViewModel(title: "兼职安全员", select: true, keyPath: "target1")
        let model2 = MLSelectedTableViewModel(title: "专职安全员", select: false, keyPath: "target2")
        return [model1, model2]
    }
    
    var uploadImageLimit: Int {return 4}
    
    var adminiTypeList: [MLSelectedTableViewModel] {
        let model1 = MLSelectedTableViewModel(title: "安全管理人", select: true, keyPath: "target1")
        let model2 = MLSelectedTableViewModel(title: "安全负责人", select: false, keyPath: "target2")
        return [model1, model2]
    }
}
