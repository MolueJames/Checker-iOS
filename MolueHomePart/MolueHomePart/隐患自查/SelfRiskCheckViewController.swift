//
//  SelfRiskCheckViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/6/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
class SelfRiskCheckViewController: MLBaseViewController {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelfRiskCheckViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患自查"
    }
}
