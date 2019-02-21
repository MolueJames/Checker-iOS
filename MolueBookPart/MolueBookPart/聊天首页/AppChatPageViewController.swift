//
//  AppChatPageViewController.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol AppChatPagePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class AppChatPageViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: AppChatPagePresentableListener?
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "常用联系人"
        return label
    } ()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AppChatPageViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.navigationItem.titleView = self.titleLabel
    }
}

extension AppChatPageViewController: AppChatPagePagePresentable {
    
}

extension AppChatPageViewController: AppChatPageViewControllable {
    
}
