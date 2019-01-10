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
    
    public var submitInfoCommand: PublishSubject<Void>?
    
    private var riskLevel: PotentialRiskLevel?
    
    private var riskClass: MLRiskClassification?
    
    private var riskPoint: MLRiskPointDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var riskClassClickView: MLCommonClickView! {
        didSet {
            riskClassClickView.defaultValue(title: "隐患类别", placeholder: "请选择隐患类别")
            riskClassClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToClassSelectController()
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func jumpToClassSelectController() {
        let builder = RiskClassificationsComponentBuilder()
        let controller = builder.build(listener: self)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    
    public func refreshSubview(with model: PotentialRiskModel?) {
        self.submitInfoCommand = PublishSubject<Void>()
    }
    
    @IBOutlet weak var riskPointClickView: MLCommonClickView! {
        didSet {
            riskPointClickView.defaultValue(title: "隐患位置", placeholder: "请选择隐患位置")
            riskPointClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToUnitSelectController()
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func jumpToUnitSelectController() {
        let builder = RiskUnitPositionComponentBuilder()
        let controller = builder.build(listener: self)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    
    @IBOutlet weak var reasonRemarkView: MLCommonRemarkView! {
        didSet {
            reasonRemarkView.defaultValue(title: "请填写当前的隐患说明", limit: 200)
        }
    }
    
    //TODO: 添加隐患级别
    @IBOutlet weak var riskLevelClickView: MLCommonClickView! {
        didSet {
            riskLevelClickView.defaultValue(title: "隐患级别", placeholder: "请选择隐患级别")
            riskLevelClickView.clickedCommand.subscribe(onNext: { [unowned self] (_) in
                self.jumpToLevelSelectController()
            }).disposed(by: self.disposeBag)
        }
    }
    
    private func jumpToLevelSelectController() {
        let builder = HiddenPerilLevelComponentBuilder()
        let controller = builder.build(listener: self)
        MoluePageNavigator.shared.pushViewController(controller)
    }
    
    private enum riskInfoRrror: LocalizedError {
        case typeInvalid
        case unitInvalid
        case levelInvalid
        case reasonInvalid
    
        public var errorDescription: String? {
            switch self {
            case .typeInvalid:
                return "请选择隐患类别"
            case .unitInvalid:
                return "请选择风险单元"
            case .levelInvalid:
                return "请选择隐患级别"
            case .reasonInvalid:
                return "请填写当前的隐患说明"
            }
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
//        guard let type = self.riskInfo.riskClass, type.isEmpty == false else{
//            self.submitInfoCommand?.onError(riskInfoRrror.typeInvalid)
//            return
//        }
//        guard let unit = self.riskInfo.riskUnit, unit.isEmpty == false else {
//            self.submitInfoCommand?.onError(riskInfoRrror.unitInvalid)
//            return
//        }
//        guard self.riskInfo.level.isSome() else {
//            self.submitInfoCommand?.onError(riskInfoRrror.levelInvalid)
//            return
//        }
//        guard self.reasonRemarkView.remarkText().isEmpty == false else {
//            self.submitInfoCommand?.onError(riskInfoRrror.reasonInvalid)
//            return
//        }
//        let checkedDate = Date().string(withFormat: "yyyy年MM月dd日")
//        self.riskInfo.checkedDate = checkedDate
//        self.riskInfo.riskDetail = self.reasonRemarkView.remarkText()
//        self.submitInfoCommand?.onNext(self.riskInfo)
    }
    
    func refreshSubviews(with attachment: MLTaskAttachment, riskUnit: MLRiskPointDetail) {
        self.riskPointClickView.update(description: riskUnit.unitName.data())
        self.reasonRemarkView.updateRemark(with: attachment.remark.data())
    }
}

extension EditRiskInfoResuableFooterView: RiskClassificationsInteractListener {
    func updateRiskClassification(with value: MLRiskClassification) {
        self.riskClassClickView.update(description: value.name.data())
        self.riskClass = value
    }
}

extension EditRiskInfoResuableFooterView: RiskUnitPositionInteractListener {
    func updateRiskPointPosition(with value: MLRiskPointDetail) {
        self.riskPointClickView.update(description: value.unitName.data())
        self.riskPoint = value
    }
}

extension EditRiskInfoResuableFooterView: HiddenPerilLevelInteractListener {
    func updatePotentialRiskLevel(with value: PotentialRiskLevel) {
        self.riskLevelClickView.update(description: value.description)
        self.riskLevel = value
    }
}
