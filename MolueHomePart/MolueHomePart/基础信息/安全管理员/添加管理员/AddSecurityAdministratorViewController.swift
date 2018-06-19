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
import ImagePicker
class AddSecurityAdministratorViewController: MLBaseViewController {
    private let limitCount = 4
    private let disposeBag = DisposeBag()
    //MARK: Interface Elements
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
    @IBOutlet private weak var uploadPhotoContainerView: MLContainerView! {
        didSet {
            uploadPhotoInputView = MLCommonPhotoView.createFromXib()
            uploadPhotoContainerView.doBespreadOn(uploadPhotoInputView)
        }
    }
    private var uploadPhotoInputView: MLCommonPhotoView! {
        didSet {
            let images = [UIImage(named: "home_page_riskCheck")!, UIImage(named: "home_page_riskCheck")!,UIImage(named: "home_page_riskCheck")!,UIImage(named: "home_page_riskCheck")!,UIImage(named: "home_page_riskCheck")!]
            uploadPhotoInputView.defaultValue(title: "上传证书", list: images, count: limitCount)
            uploadPhotoInputView.appendCommand.subscribe(onNext: { [unowned self] (leftCount) in
                self.pushToImagePick(leftCount: leftCount)
            }).disposed(by: disposeBag)
        }
    }
    //MARK: Interface Functions
    private func pushToImagePick(leftCount: Int) {
        if leftCount > 0 {
            let pickerController = self.imagePickerController(leftCount)
            self.tabBarController?.present(pickerController, animated: true)
        } else {
            self.showWarningHUD(text: "对不起,只允许选择\(limitCount)张图片")
        }
    }
    
    private func imagePickerController(_ leftCount: Int) -> ImagePickerController {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = leftCount
        return imagePickerController
    }
    
    private func pushToAdminiType() {
        let model1 = MLSelectedTableViewModel(title: "安全管理人", select: true, keyPath: "target1")
        let model2 = MLSelectedTableViewModel(title: "安全负责人", select: false, keyPath: "target2")
        let list = [model1, model2]
        let controller = MLSingleSelectController<MLSelectedTableViewModel>()
        controller.updateValues(title: "人员类型", list: list)
        controller.selectCommand.subscribe(onNext: { [unowned self] (model) in
            self.adminiTypeInputView.update(description: model.description)
        }).disposed(by: disposeBag)
        self.navigationController?.pushViewController(controller, animated: true)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//TODO: 实现这些协议方法
extension AddSecurityAdministratorViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.uploadPhotoInputView.appendImages(images)
        imagePicker.dismiss(animated: true)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.uploadPhotoInputView.appendImages(images)
        imagePicker.dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}

extension AddSecurityAdministratorViewController: MolueNavigatorProtocol {
    func doTransferParameters(params: Any?) {
        
    }
    func doSettingParameters(params: Dictionary<String, String>) {
        if let title = params["title"]  {
            self.title = title
        }
        self.title = "添加管理员"
    }
}
