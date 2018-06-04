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
            resresentInputView.update(title: "法人代表", placeholder: "请输入法定代表人姓名")
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
            contactNoInputView.update(title: "企业电话", placeholder: "请输入企业联系电话")
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
            phoneNoInputView.update(title: "法人手机", placeholder: "请输入法定代表人手机号")
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
            addressInputView.update(title: "经营地址", placeholder: "自动获取地址 >")
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
            faxNumberInputView.update(title: "传真号码", placeholder: "请输入企业传真号码")
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
            postalCodeInputView.update(title: "邮政编码", placeholder: "请输入邮政编码")
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
            emailInputView.update(title: "企业邮箱", placeholder: "请输入企业邮箱")
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
            websiteInputView.update(title: "企业网站", placeholder: "请输入企业网站地址")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "联络信息"
        let submitButton = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submitButtonClicked))
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    @IBAction func submitButtonClicked(_ sender: UIBarButtonItem) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
