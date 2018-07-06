//
//  ContactInformationViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueFoundation
import MolueUtilities
import MolueCommon
class ContactInfoViewController: MLBaseViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var resresentInputView: MLCommonInputView! {
        didSet {
            resresentInputView.defaultValue(title: "法人代表", placeholder: "请输入法定代表人姓名")
        }
    }
    @IBOutlet weak var contactNoInputView: MLCommonInputView! {
        didSet {
            contactNoInputView.defaultValue(title: "企业电话", placeholder: "请输入企业联系电话")
        }
    }
    @IBOutlet weak var phoneNoInputView: MLCommonInputView! {
        didSet {
            phoneNoInputView.defaultValue(title: "法人手机", placeholder: "请输入法定代表人手机号", keyboardType: .numberPad)
        }
    }
    @IBOutlet weak var addressInputView: MLCommonClickView! {
        didSet {
            addressInputView.defaultValue(title: "经营地址", placeholder: "自动获取地址 >")
            addressInputView.clickedCommand.subscribe(onNext: { (_) in
                MolueLogger.success.message("clicked")
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var faxNumberInputView: MLCommonInputView! {
        didSet {
            faxNumberInputView.defaultValue(title: "传真号码", placeholder: "请输入企业传真号码")
        }
    }
    @IBOutlet weak var postalCodeInputView: MLCommonInputView! {
        didSet {
            postalCodeInputView.defaultValue(title: "邮政编码", placeholder: "请输入邮政编码", keyboardType: .numberPad)
        }
    }
    @IBOutlet weak var emailInputView: MLCommonInputView! {
        didSet {
            emailInputView.defaultValue(title: "企业邮箱", placeholder: "请输入企业邮箱", keyboardType: .emailAddress)
        }
    }
    @IBOutlet weak var websiteInputView: MLCommonInputView! {
        didSet {
            websiteInputView.defaultValue(title: "企业网站", placeholder: "请输入企业网站地址", keyboardType: .URL)
        }
    }
    
    @IBAction private func submitButtonClicked(_ sender: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ContactInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "联络信息"
        let submitButton = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submitButtonClicked))
        self.navigationItem.rightBarButtonItem = submitButton
    }
}
