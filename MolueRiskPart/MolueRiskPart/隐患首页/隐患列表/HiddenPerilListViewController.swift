//
//  HiddenPerilListViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol HiddenPerilListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class HiddenPerilListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: HiddenPerilListPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HiddenPerilListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension HiddenPerilListViewController: HiddenPerilListPagePresentable {
    
}

extension HiddenPerilListViewController: HiddenPerilListViewControllable {
    
}
