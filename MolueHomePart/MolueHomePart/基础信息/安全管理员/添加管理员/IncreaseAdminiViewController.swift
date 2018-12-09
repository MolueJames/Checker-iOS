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
import Kingfisher
import ObjectMapper

protocol IncreaseAdminiNavigatorProtocol: MLAppNavigatorProtocol {
    func selectController(title: String, list: [MLSelectedTableViewModel]) -> MLSingleSelectController<MLSelectedTableViewModel>
}

protocol IncreaseAdminiDataProtocol: MLDataManagerProtocol {
    var uploadImageLimit: Int {get}
    var adminiTypeList: [MLSelectedTableViewModel] {get}
    var fullTimeList: [MLSelectedTableViewModel] {get}
}

class IncreaseAdminiViewController: MLBaseViewController {
    private let disposeBag = DisposeBag()
    private let dataManager: IncreaseAdminiDataProtocol = IncreaseAdminiDataManager()
    private let navigator: IncreaseAdminiNavigatorProtocol = IncreaseAdminiNavigator()
    
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
            adminiTypeInputView.defaultValue(title: "职务", placeholder: "请选择人员职务")
            adminiTypeInputView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                let list = self.dataManager.adminiTypeList
                self.pushToSelectController(title: "人员职务", list: list)
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
//    @IBOutlet private weak var uploadPhotoInputView: MLCommonPhotoView! {
//        didSet {
//            let count = self.dataManager.uploadImageLimit
//            uploadPhotoInputView.defaultValue(title: "上传证书", list: [UIImage](), count: count)
//            uploadPhotoInputView.appendCommand.subscribe(onNext: { [unowned self] (leftCount) in
//                self.pushToImagePick(leftCount: leftCount)
//            }).disposed(by: disposeBag)
//        }
//    }
    
    @IBOutlet weak var telephoneInputView: MLCommonInputView! {
        didSet {
            telephoneInputView.defaultValue(title: "固话", placeholder: "请输入固话号码(选填)")
            telephoneInputView.textChangedCommand.subscribe(onNext: { (value) in
                
            }).disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var fullTimeAdminiClickView: MLCommonClickView! {
        didSet {
            fullTimeAdminiClickView.defaultValue(title: "专职", placeholder: "请选择是否为专职安全员")
            fullTimeAdminiClickView.clickedCommand.subscribe(onNext: { [unowned self] (value) in
                let list = self.dataManager.fullTimeList
                self.pushToSelectController(title: "安全员类型", list: list)
            }).disposed(by: disposeBag)
        }
    }
    //MARK: Interface Functions
    private func pushToImagePick(leftCount: Int) {
        if leftCount > 0 {
//            let pickerController = self.imagePickerController(leftCount)
//            self.navigator.present(pickerController)
        } else {
            let limitCount = self.dataManager.uploadImageLimit
            self.showWarningHUD(text: "对不起,只允许选择\(limitCount)张图片")
        }
    }
    
//    private func imagePickerController(_ leftCount: Int) -> ImagePickerController {
//        let imagePickerController = ImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.imageLimit = leftCount
//        return imagePickerController
//    }
    
    private func pushToSelectController(title: String, list: [MLSelectedTableViewModel]) {
        let list = self.dataManager.fullTimeList
        let controller = self.navigator.selectController(title: "安全员类型", list: list)
        controller.selectCommand.subscribe(onNext: { [unowned self] (model) in
            self.fullTimeAdminiClickView.update(description: model.description)
        }).disposed(by: disposeBag)
        self.navigator.push(controller)
    }
    
    private func presentDatePicker() {
//        let router = MolueNavigatorRouter(.Common, path: CommonPath.DatePicker.rawValue)
//        let controller: MLDatePickerViewController! = MolueAppRouter.shared.viewController(router)
//        controller.modalPresentationStyle = .overCurrentContext
//        controller.selectDateCommand.subscribe(onNext: { [unowned self] (date, string) in
//            self.updateDeadLineValue(date: date, string: string)
//        }).disposed(by: disposeBag)
//        self.navigator.present(controller)
    }
    private func updateDeadLineValue(date: Date, string: String) {
        self.deadLineInputView.update(description: string)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IncreaseAdminiViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
 
    }
}

//TODO: 实现这些协议方法
//extension IncreaseAdminiViewController: ImagePickerDelegate {
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        self.uploadPhotoInputView.appendImages(images)
//        imagePicker.dismiss(animated: true)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        self.uploadPhotoInputView.appendImages(images)
//        imagePicker.dismiss(animated: true)
//    }
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        imagePicker.dismiss(animated: true)
//    }
//}

extension IncreaseAdminiViewController: MolueNavigatorProtocol {
    func doTransferParameters<T>(params: T?) {
        
    }
    
    func doTransferParameters(params: Any?) {
        
    }
    func doSettingParameters(params: String) {
        
    }
}

extension IncreaseAdminiViewController: MolueVIPBuilderProtocol {
    static func doBulildVIPComponent() -> UIViewController? {
        let viewController = self.initializeFromStoryboard()
//        let interactor = IncreaseAdminInteractor()
//        viewController.listener = interactor
//        interactor.presenter = viewController
        
        return viewController
    }
}


