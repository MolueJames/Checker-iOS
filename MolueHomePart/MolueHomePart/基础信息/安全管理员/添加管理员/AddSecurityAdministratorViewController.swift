//
//  AddSecurityAdministratorViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueNavigator
import MolueCommon
import RxSwift
import MolueUtilities
class AddSecurityAdministratorViewController: MLBaseViewController, MolueNavigatorProtocol {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var usernameContainerView: MLContainerView! {
        didSet {
            usernameInputView = MLCommonInputView.createFromXib()
            usernameContainerView.doBespreadOn(usernameInputView)
        }
    }
    private var usernameInputView: MLCommonInputView! {
        didSet {
            usernameInputView.defaultValue(title: "姓名", placeholder: "请输入人员姓名")
        }
    }
    @IBOutlet private weak var phoneNoContainerView: MLContainerView! {
        didSet {
            phoneNoInputView = MLCommonInputView.createFromXib()
            phoneNoContainerView.doBespreadOn(phoneNoInputView)
        }
    }
    private var phoneNoInputView: MLCommonInputView! {
        didSet {
            phoneNoInputView.defaultValue(title: "手机", placeholder: "请输入人员手机号", keyboardType: .numberPad)
        }
    }
    @IBOutlet private weak var idCardNoContainerView: MLContainerView! {
        didSet {
            idCardNoInputView = MLCommonInputView.createFromXib()
            idCardNoContainerView.doBespreadOn(idCardNoInputView)
        }
    }
    private var idCardNoInputView: MLCommonInputView! {
        didSet {
            idCardNoInputView.defaultValue(title: "身份证", placeholder: "请输入人员身份证", keyboardType: .numberPad)
        }
    }
    @IBOutlet private weak var adminiTypeContainerView: MLContainerView! {
        didSet {
            adminiTypeInputView = MLCommonClickView.createFromXib()
            adminiTypeContainerView.doBespreadOn(adminiTypeInputView)
        }
    }
    private var adminiTypeInputView: MLCommonClickView! {
        didSet {
            adminiTypeInputView.defaultValue(title: "类型", placeholder: "请选择人员类型")
            adminiTypeInputView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.pushToAdminiType()
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var certificateNoContainerView: MLContainerView! {
        didSet {
            certificateNoInputView = MLCommonInputView.createFromXib()
            certificateNoContainerView.doBespreadOn(certificateNoInputView)
        }
    }
    private var certificateNoInputView: MLCommonInputView! {
        didSet {
            certificateNoInputView.defaultValue(title: "证书编号", placeholder: "请输入证书编号", keyboardType: .numberPad)
            certificateNoInputView.textChangedCommand.subscribe(onNext: { (value) in
                
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var deadLineContainerView: MLContainerView! {
        didSet {
            deadLineInputView = MLCommonClickView.createFromXib()
            deadLineContainerView.doBespreadOn(deadLineInputView)
        }
    }
    private var deadLineInputView: MLCommonClickView! {
        didSet {
            deadLineInputView.defaultValue(title: "有效期至", placeholder: "请选择证书有效截止日期")
            deadLineInputView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.presentDatePicker()
            }).disposed(by: disposeBag)
        }
    }
    
    private func pushToAdminiType() {
        let router = MolueNavigatorRouter(.Common, path: CommonPath.selectTable.rawValue)
        let controller: MLSelectedTableController! = MolueAppRouter.shared.pushRouter(router)
        print(controller)
    }
    
    private func presentDatePicker() {
        let router = MolueNavigatorRouter(.Common, path: CommonPath.datePicker.rawValue)
        let controller: MLDatePickerViewController! = MolueAppRouter.shared.viewController(router)
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
        controller.selectDateCommand.subscribe(onNext: { [unowned self] (date, string) in
            self.updateDeadLineValue(date: date, string: string)
        }).disposed(by: disposeBag)
    }
    private func updateDeadLineValue(date: Date, string: String) {
        MolueLogger.warning.message((date, string))
        self.deadLineInputView.update(description: string)
    }
    
    @IBOutlet private weak var uploadPhotoContainerView: MLContainerView! {
        didSet {
            
        }
    }
    private var uploadPhotoInputView: MLCommonInputView! {
        didSet {
            
        }
    }
    func doTransferParameters(params: Any?) {
        
    }
    func doSettingParameters(params: Dictionary<String, String>) {
        guard let title = params["title"] else {
            self.title = "添加管理员"; return
        }
        self.title = title
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
