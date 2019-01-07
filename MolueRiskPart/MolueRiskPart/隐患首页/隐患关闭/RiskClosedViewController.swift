//
//  RiskClosedViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskClosedPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskClosedViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskClosedPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskClosedViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskClosedViewController: RiskClosedPagePresentable {
    
}

extension RiskClosedViewController: RiskClosedViewControllable {
    
}
