//
//  RiskRectifyViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskRectifyPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskRectifyViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskRectifyPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskRectifyViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskRectifyViewController: RiskRectifyPagePresentable {
    
}

extension RiskRectifyViewController: RiskRectifyViewControllable {
    
}
