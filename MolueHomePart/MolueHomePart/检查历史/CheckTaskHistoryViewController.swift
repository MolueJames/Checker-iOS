//
//  CheckTaskHistoryViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol CheckTaskHistoryPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class CheckTaskHistoryViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskHistoryPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CheckTaskHistoryViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension CheckTaskHistoryViewController: CheckTaskHistoryPagePresentable {
    
}

extension CheckTaskHistoryViewController: CheckTaskHistoryViewControllable {
    
}
