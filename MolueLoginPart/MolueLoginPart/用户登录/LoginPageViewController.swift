//
//  LoginPageViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/7/26.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import UIKit
import MolueCommon
import MolueUtilities
import MolueFoundation
protocol LoginPagePresentableListener: class {
    func showTest()
}

class LoginPageViewController: MLBaseViewController, MolueLoginPagePresentable {
    var listener: LoginPagePresentableListener?

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
//        let name = MolueNotification.molue_user_login.toName()
//        NotificationCenter.default.post(name: name, object: nil)
        self.listener?.showTest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginPageViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.hideNavigationBar()
        self.view.backgroundColor = .white
    }
}
