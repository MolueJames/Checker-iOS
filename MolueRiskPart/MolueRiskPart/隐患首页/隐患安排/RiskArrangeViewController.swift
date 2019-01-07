//
//  RiskArrangeViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskArrangePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskArrangeViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskArrangePresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskArrangeViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskArrangeViewController: RiskArrangePagePresentable {
    
}

extension RiskArrangeViewController: RiskArrangeViewControllable {
    
}
