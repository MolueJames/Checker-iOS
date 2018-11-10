//
//  RiskPlanViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskPlanPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskPlanViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskPlanPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskPlanViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskPlanViewController: RiskPlanPagePresentable {
    
}

extension RiskPlanViewController: RiskPlanViewControllable {
    
}
