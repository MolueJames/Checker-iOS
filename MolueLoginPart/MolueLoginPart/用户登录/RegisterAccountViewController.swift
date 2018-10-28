//
//  RegisterAccountViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/26.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RegisterAccountPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RegisterAccountViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RegisterAccountPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RegisterAccountViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RegisterAccountViewController: RegisterAccountPagePresentable {
    
}

extension RegisterAccountViewController: RegisterAccountViewControllable {
    
}
