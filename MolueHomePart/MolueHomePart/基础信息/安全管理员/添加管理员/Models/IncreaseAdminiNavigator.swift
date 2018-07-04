//
//  IncreaseAdminiNavigator.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/7/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import RxSwift
import MolueCommon

struct IncreaseAdminiNavigator: IncreaseAdminiNavigatorProtocol {    
    func selectController(title: String, list: [MLSelectedTableViewModel]) -> MLSingleSelectController<MLSelectedTableViewModel> {
        let controller = MLSingleSelectController<MLSelectedTableViewModel>()
        controller.updateValues(title: title, list: list)
        return controller
    }
}
