//
//  RiskFollowViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskFollowPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskFollowViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskFollowPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskFollowViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskFollowViewController: RiskFollowPagePresentable {
    
}

extension RiskFollowViewController: RiskFollowViewControllable {
    
}
