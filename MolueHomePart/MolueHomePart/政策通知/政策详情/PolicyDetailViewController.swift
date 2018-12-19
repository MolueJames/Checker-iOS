//
//  PolicyDetailViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueNetwork
import MolueFoundation

protocol PolicyDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var selectedNotification: MLPolicyNoticeModel? {get}
}

final class PolicyDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PolicyDetailPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PolicyDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension PolicyDetailViewController: PolicyDetailPagePresentable {
    
}

extension PolicyDetailViewController: PolicyDetailViewControllable {
    
}
