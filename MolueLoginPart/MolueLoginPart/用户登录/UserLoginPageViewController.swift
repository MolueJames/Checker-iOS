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
    func doUserLogin(with username: String, password: String)
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
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var loginContainView: UIView! {
        didSet {
            loginContainView.layer.masksToBounds = false
            let color = MLCommonColor.titleLabel.cgColor
            loginContainView.layer.borderColor = color
            loginContainView.layer.shadowOffset = CGSize(width: 2, height: 4)
            loginContainView.layer.shadowRadius = 4;
            loginContainView.layer.shadowOpacity = 0.2
            loginContainView.layer.cornerRadius = 5
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
        self.view.sendSubviewToBack(self.navigationView)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            let username = try self.isUsername(with: usernameTextField)
            let password = try self.isPassword(with: passwordTextField)
            listener.doUserLogin(with: username, password: password)
        } catch {
            let message = error.localizedDescription
            self.showFailureHUD(text: message)
        }

    }
    
    private enum ValidInputError: LocalizedError {
        case username
        case password
        
        public var errorDescription: String? {
            switch self {
            case .username:
                return "请输入正确的手机号码"
            case .password:
                return "请输入正确的登录密码"
            }
        }
    }
    
    private func isUsername(with textfield: UITextField) throws -> String {
        do {
            let username = try textfield.text.unwrap()
            if username.isPhoneNo { return username }
            textfield.becomeFirstResponder()
            throw ValidInputError.username
        } catch {
            throw ValidInputError.username
        }
    }
    
    private func isPassword(with textfield: UITextField) throws -> String {
        do {
            let password = try textfield.text.unwrap()
            if password.isPassword { return password }
            textfield.becomeFirstResponder()
            throw ValidInputError.password
        } catch {
            throw ValidInputError.password
        }
    }
    
    
    @IBAction func forgetButtonClicked(_ sender: UIButton) {
        do {
            try self.listener.unwrap().routerToForgetPassword()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
