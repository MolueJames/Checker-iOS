//
//  CommonWebViewController.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/12/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol CommonWebPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class CommonWebViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CommonWebPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CommonWebViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension CommonWebViewController: CommonWebPagePresentable {
    
}

extension CommonWebViewController: CommonWebViewControllable {
    
}
