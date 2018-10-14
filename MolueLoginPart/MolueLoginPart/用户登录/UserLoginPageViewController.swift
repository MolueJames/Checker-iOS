//
//  UserLoginPageViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
import MolueCommon

protocol UserLoginPagePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func routerToForgetPassword()
}

final class UserLoginPageViewController: MLBaseViewController, UserLoginPagePagePresentable, UserLoginPageViewControllable {

    var listener: UserLoginPagePresentableListener?
    
    @IBOutlet weak var appIconView: UIView! {
        didSet {
            let color = MLCommonColor.titleLabel
            let offset = CGSize(width: 2, height: 4)
            appIconView.addShadow(ofColor: color, offset: offset)
        }
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            //            submitButton.layer.cornerRadius = 23
        }
    }
    @IBOutlet weak var loginContainView: UIView! {
        didSet {
            loginContainView.clipsToBounds = false
            let color = MLCommonColor.titleLabel.cgColor
            loginContainView.layer.borderColor = color
            loginContainView.layer.shadowOffset = CGSize(width: 2, height: 4)
            loginContainView.layer.shadowRadius = 4;
            loginContainView.layer.shadowOpacity = 0.2
            loginContainView.layer.cornerRadius = 5
        }
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        let name = MolueNotification.molue_user_login.toName()
        NotificationCenter.default.post(name: name, object: nil)
    }
    
    @IBAction func forgetButtonClicked(_ sender: UIButton) {
        do {
            try self.listener.unwrap().routerToForgetPassword()
        } catch {
            MolueLogger.failure.error(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension UserLoginPageViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}
