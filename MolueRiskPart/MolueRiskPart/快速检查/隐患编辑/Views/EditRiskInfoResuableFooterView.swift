//
//  EditRiskInfoResuableFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon
import MolueUtilities
import MolueMediator
import JGProgressHUD

class EditRiskInfoResuableFooterView: UICollectionReusableView {
    private let disposeBag = DisposeBag()
    
    public var submitInfoCommand: PublishSubject<PotentialRiskModel>?
    
    lazy var riskInfo: PotentialRiskModel = {
        var riskInfo = PotentialRiskModel()
        riskInfo.channel = .enterprise
        riskInfo.status = .never
        riskInfo.personDetail = "张三"
        return riskInfo
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var riskTypeClickView: MLCommonClickView! {
        didSet {
            riskTypeClickView.defaultValue(title: "隐患类别", placeholder: "请选择隐患类别")
            riskTypeClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToTypeSelectController()
            }).disposed(by: disposeBag)
        }
    }
    
    private func jumpToTypeSelectController() {
        let riskClassList: [String] = AppRiskDocument.shared.riskClassList
        let controller = MLSingleSelectController<String>()
        controller.updateValues(title: "隐患类别", list: riskClassList)
        controller.selectCommand.subscribe(onNext: { [unowned self] (model) in
            self.riskTypeClickView.update(description: model)
            self.riskInfo.riskClass = model
        }).disposed(by: self.disposeBag)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    
    public func refreshSubview(with model: PotentialRiskModel?) {
        self.submitInfoCommand = PublishSubject<PotentialRiskModel>()
    }
    
    @IBOutlet weak var deadLineClickView: MLCommonClickView! {
        didSet {
            deadLineClickView.defaultValue(title: "整改日期", placeholder: "请选择整改完成日期")
            deadLineClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.presentDeadLineController()
            }).disposed(by: disposeBag)
        }
    }
    
    private func presentDeadLineController() {
        let controller = MLDatePickerViewController.initializeFromStoryboard()
        controller.modalPresentationStyle = .overCurrentContext
        controller.selectDateCommand.subscribe(onNext: { [unowned self] (date, string) in
            self.deadLineClickView.update(description: string)
            self.riskInfo.finishDate = string
        }).disposed(by: disposeBag)
        MoluePageNavigator.shared.presentViewController(controller)
    }
    
    @IBOutlet weak var riskUnitClickView: MLCommonClickView! {
        didSet {
            riskUnitClickView.defaultValue(title: "风险单元", placeholder: "请选择风险单元")
            riskUnitClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToUnitSelectController()
            }).disposed(by: disposeBag)
        }
    }
    
    private func jumpToUnitSelectController() {
        let riskUnitList: [String] = AppRiskDocument.shared.riskUnitList
        let controller = MLSingleSelectController<String>()
        controller.updateValues(title: "风险单元", list: riskUnitList)
        controller.selectCommand.subscribe(onNext: { [unowned self] (model) in
            self.riskUnitClickView.update(description: model)
            self.riskInfo.riskUnit = model
        }).disposed(by: self.disposeBag)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    
    @IBOutlet weak var reasonRemarkView: MLCommonRemarkView! {
        didSet {
            reasonRemarkView.defaultValue(title: "请填写具体情况及整改措施方案", limit: 100)
        }
    }
    
    //TODO: 添加隐患级别
    @IBOutlet weak var riskLevelClickView: MLCommonClickView! {
        didSet {
            riskLevelClickView.defaultValue(title: "隐患级别", placeholder: "请选择隐患级别")
            riskLevelClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToLevelSelectController()
            }).disposed(by: disposeBag)
        }
    }
    
    private func jumpToLevelSelectController() {
        let riskLevelList: [PotentialRiskLevel] = PotentialRiskLevel.allCases
        let controller = MLSingleSelectController<PotentialRiskLevel>()
        controller.updateValues(title: "隐患级别", list: riskLevelList)
        controller.selectCommand.subscribe(onNext: { [unowned self] (model) in
            self.riskLevelClickView.update(description: model.description)
            self.riskInfo.level = model
        }).disposed(by: self.disposeBag)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    private enum riskInfoRrror: LocalizedError {
        case typeInvalid
        case dateInvalid
        case unitInvalid
        case levelInvalid
        case reasonInvalid
    
        public var errorDescription: String? {
            switch self {
            case .typeInvalid:
                return "请选择隐患类别"
            case .dateInvalid:
                return "请选择整改完成日期"
            case .unitInvalid:
                return "请选择风险单元"
            case .levelInvalid:
                return "请选择隐患级别"
            case .reasonInvalid:
                return "请填写具体情况及整改措施方案"
            }
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        guard let type = self.riskInfo.riskClass, type.isEmpty == false else{
            self.submitInfoCommand?.onError(riskInfoRrror.typeInvalid)
            return
        }
        guard let date = self.riskInfo.finishDate, date.isEmpty == false else {
            self.submitInfoCommand?.onError(riskInfoRrror.dateInvalid)
            return
        }
        guard let unit = self.riskInfo.riskUnit, unit.isEmpty == false else {
            self.submitInfoCommand?.onError(riskInfoRrror.unitInvalid)
            return
        }
        guard self.riskInfo.level.isSome() else {
            self.submitInfoCommand?.onError(riskInfoRrror.levelInvalid)
            return
        }
        guard self.reasonRemarkView.remarkText().isEmpty == false else {
            self.submitInfoCommand?.onError(riskInfoRrror.reasonInvalid)
            return
        }
        let checkedDate = Date().string(withFormat: "yyyy年MM月dd日")
        self.riskInfo.checkedDate = checkedDate
        self.riskInfo.riskDetail = self.reasonRemarkView.remarkText()
        self.submitInfoCommand?.onNext(self.riskInfo)
    }
}
