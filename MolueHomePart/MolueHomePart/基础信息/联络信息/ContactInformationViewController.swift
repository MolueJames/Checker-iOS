//
//  ContactInformationViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueCommon
class ContactInformationViewController: MLBaseViewController {

    @IBOutlet weak var representContainerView: MLContainerView! {
        didSet {
            resresentInputView = MLCommonInputView.createFromXib()
            representContainerView.doBespreadOn(resresentInputView)
        }
    }
    var resresentInputView: MLCommonInputView! {
        didSet {
            resresentInputView.defaultValue(title: "法人代表", placeholder: "请输入法定代表人姓名")
        }
    }
    
    @IBOutlet weak var contactNoContainerView: MLContainerView! {
        didSet {
            contactNoInputView = MLCommonInputView.createFromXib()
            contactNoContainerView.doBespreadOn(contactNoInputView)
        }
    }
    var contactNoInputView: MLCommonInputView! {
        didSet {
            contactNoInputView.defaultValue(title: "企业电话", placeholder: "请输入企业联系电话")
        }
    }
    @IBOutlet weak var phoneNoContainerView: MLContainerView! {
        didSet {
            phoneNoInputView = MLCommonInputView.createFromXib()
            phoneNoContainerView.doBespreadOn(phoneNoInputView)
        }
    }
    var phoneNoInputView: MLCommonInputView! {
        didSet {
            phoneNoInputView.defaultValue(title: "法人手机", placeholder: "请输入法定代表人手机号", keyboardType: .numberPad)
        }
    }
    @IBOutlet weak var addressContainerView: MLContainerView! {
        didSet {
            addressInputView = MLCommonInputView.createFromXib()
            addressContainerView.doBespreadOn(addressInputView)
        }
    }
    var addressInputView: MLCommonInputView! {
        didSet {
            addressInputView.defaultValue(title: "经营地址", placeholder: "自动获取地址 >")
        }
    }
    
    @IBOutlet weak var faxNumberContainerView: MLContainerView! {
        didSet {
            faxNumberInputView = MLCommonInputView.createFromXib()
            faxNumberContainerView.doBespreadOn(faxNumberInputView)
        }
    }
    var faxNumberInputView: MLCommonInputView! {
        didSet {
            faxNumberInputView.defaultValue(title: "传真号码", placeholder: "请输入企业传真号码")
        }
    }
    @IBOutlet weak var postalCodeContainerView: MLContainerView! {
        didSet {
            postalCodeInputView = MLCommonInputView.createFromXib()
            postalCodeContainerView.doBespreadOn(postalCodeInputView)
        }
    }
    var postalCodeInputView: MLCommonInputView! {
        didSet {
            postalCodeInputView.defaultValue(title: "邮政编码", placeholder: "请输入邮政编码", keyboardType: .numberPad)
        }
    }
    @IBOutlet weak var EmailContainerView: MLContainerView! {
        didSet {
            emailInputView = MLCommonInputView.createFromXib()
            EmailContainerView.doBespreadOn(emailInputView)
        }
    }
    var emailInputView: MLCommonInputView! {
        didSet {
            emailInputView.defaultValue(title: "企业邮箱", placeholder: "请输入企业邮箱", keyboardType: .emailAddress)
        }
    }
    @IBOutlet weak var websiteContainerView: MLContainerView! {
        didSet {
            websiteInputView = MLCommonInputView.createFromXib()
            websiteContainerView.doBespreadOn(websiteInputView)
        }
    }
    var websiteInputView: MLCommonInputView! {
        didSet {
            websiteInputView.defaultValue(title: "企业网站", placeholder: "请输入企业网站地址", keyboardType: .URL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "联络信息"
        let submitButton = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submitButtonClicked))
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    @IBAction private func submitButtonClicked(_ sender: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
