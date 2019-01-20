//
//  RiskAcceptViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskAcceptPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskAcceptViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskAcceptPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskAcceptViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskAcceptViewController: RiskAcceptPagePresentable {
    
}

extension RiskAcceptViewController: RiskAcceptViewControllable {
    
}
