//
//  HomeInfoNavigator.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/6/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueNavigator
import MolueCommon
public struct HomeInfoNavigator: HomeInfoNavigatorProtocol {
    func pushToEnterpriseInfo() {
        let target = MolueNavigatorRouter(.Home, path: HomePath.EnterpriseInfo.rawValue)
        router?.push(target, needHideBottomBar: true)
    }
    
    func pushToSelfRiskCheck() {
        let target = MolueNavigatorRouter(.Home, path: HomePath.SelfRiskCheck.rawValue)
        router?.push(target, needHideBottomBar: true)
    }
    
    func pushToLawRegulation() {
        let target = MolueNavigatorRouter(.Home, path: HomePath.LawRegulation.rawValue)
        router?.push(target, needHideBottomBar: true)
    }
    
    func pushToPolicyNotice()  {
        let target = MolueNavigatorRouter(.Home, path: HomePath.PolicyNotice.rawValue)
        router?.push(target, needHideBottomBar: true)
    }
}
