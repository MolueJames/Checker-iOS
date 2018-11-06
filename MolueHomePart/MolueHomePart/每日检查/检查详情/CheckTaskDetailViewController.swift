//
//  CheckTaskDetailViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol CheckTaskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class CheckTaskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskDetailPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CheckTaskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension CheckTaskDetailViewController: CheckTaskDetailPagePresentable {
    
}

extension CheckTaskDetailViewController: CheckTaskDetailViewControllable {
    
}
