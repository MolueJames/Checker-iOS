//
//  AboutUsInfoViewController.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol AboutUsInfoPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class AboutUsInfoViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: AboutUsInfoPresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AboutUsInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "关于我们"
    }
}

extension AboutUsInfoViewController: AboutUsInfoPagePresentable {
    
}

extension AboutUsInfoViewController: AboutUsInfoViewControllable {
    
}
