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
import Kingfisher
import ObjectMapper


class IncreaseAdminiViewController: MLBaseViewController {
    private let limitCount = 4
    private let disposeBag = DisposeBag()
    //MARK: Interface Elements
    @IBOutlet private weak var usernameInputView: MLCommonInputView! {
        didSet {
            usernameInputView.defaultValue(title: "姓名", placeholder: "请输入人员姓名")
        }
    }
    @IBOutlet private weak var phoneNoInputView: MLCommonInputView! {
        didSet {
            phoneNoInputView.defaultValue(title: "手机", placeholder: "请输入人员手机号", keyboardType: .numberPad)
        }
    }
    @IBOutlet private weak var idCardNoInputView: MLCommonInputView! {
        didSet {
            idCardNoInputView.defaultValue(title: "身份证", placeholder: "请输入人员身份证", keyboardType: .numberPad)
        }
    }
    @IBOutlet private weak var adminiTypeInputView: MLCommonClickView! {
        didSet {
            adminiTypeInputView.defaultValue(title: "类型", placeholder: "请选择人员类型")
            adminiTypeInputView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.pushToAdminiType()
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var certificateNoInputView: MLCommonInputView! {
        didSet {
            certificateNoInputView.defaultValue(title: "证书编号", placeholder: "请输入证书编号", keyboardType: .numberPad)
            certificateNoInputView.textChangedCommand.subscribe(onNext: { (value) in
                
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var deadLineInputView: MLCommonClickView! {
        didSet {
            deadLineInputView.defaultValue(title: "有效期至", placeholder: "请选择证书有效截止日期")
            deadLineInputView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.presentDatePicker()
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet private weak var uploadPhotoInputView: MLCommonPhotoView! {
        didSet {
            uploadPhotoInputView.defaultValue(title: "上传证书", list: [UIImage](), count: limitCount)
            uploadPhotoInputView.appendCommand.subscribe(onNext: { [unowned self] (leftCount) in
                self.pushToImagePick(leftCount: leftCount)
            }).disposed(by: disposeBag)
        }
    }
    //MARK: Interface Functions
    private func pushToImagePick(leftCount: Int) {
        if leftCount > 0 {
            let pickerController = self.imagePickerController(leftCount)
            self.present(pickerController, animated: false)
//            self.navigationController?.pushViewController(pickerController, animated: true)
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
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    private func presentDatePicker() {
        let router = MolueNavigatorRouter(.Common, path: CommonPath.datePicker.rawValue)
        let controller: MLDatePickerViewController! = MolueAppRouter.shared.viewController(router)
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    private func updateDeadLineValue(date: Date, string: String) {
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
extension IncreaseAdminiViewController: ImagePickerDelegate {
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

extension IncreaseAdminiViewController: MolueNavigatorProtocol {
    
    func doTransferParameters(params: Any?) {

    }
    func doSettingParameters(params: String) {
        
    }
}

extension IncreaseAdminiViewController: MLSelectedSignleProtocol, MLDatePickerProtocol {
    func selectDate(_ date: Date, string: String, controller: MLDatePickerViewController) {
        self.updateDeadLineValue(date: date, string: string)
    }
    
    func selected<T>(controller: MLSingleSelectController<T>, value: T) where T : CustomStringConvertible {
        self.adminiTypeInputView.update(description: value.description)
    }
}
