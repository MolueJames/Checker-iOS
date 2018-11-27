//
//  NoHiddenDetailViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol NoHiddenDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class NoHiddenDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: NoHiddenDetailPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension NoHiddenDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension NoHiddenDetailViewController: NoHiddenDetailPagePresentable {
    
}

extension NoHiddenDetailViewController: NoHiddenDetailViewControllable {
    
}
