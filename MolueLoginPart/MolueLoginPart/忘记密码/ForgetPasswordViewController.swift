//
//  ForgetPasswordViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation

protocol ForgetPasswordPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class ForgetPasswordViewController: MLBaseViewController, ForgetPasswordPagePresentable, ForgetPasswordViewControllable {

    var listener: ForgetPasswordPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ForgetPasswordViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}
