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
    
    public var submitInfoCommand: PublishSubject<MLHiddenPerilItem>?
    
    private var riskLevel: PotentialRiskLevel?
    
    private var riskClass: MLRiskClassification?
    
    private var riskPoint: MLRiskPointDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.submitInfoCommand = PublishSubject<MLHiddenPerilItem>()
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
        do {
            let submitInfoCommand = try self.submitInfoCommand.unwrap()
            guard let classification = self.riskClass else{
                submitInfoCommand.onError(riskInfoRrror.typeInvalid)
                return
            }
            guard let level = self.riskLevel else {
                submitInfoCommand.onError(riskInfoRrror.levelInvalid)
                return
            }
            guard let point = self.riskPoint else {
                submitInfoCommand.onError(riskInfoRrror.unitInvalid)
                return
            }
            let memo = self.reasonRemarkView.remarkText()
            guard memo.isEmpty == false else {
                submitInfoCommand.onError(riskInfoRrror.reasonInvalid)
                return
            }
            
            let hiddenPeril: MLHiddenPerilItem = {
                let item = MLHiddenPerilItem()
                item.classification = classification
                item.grade = level.toService
                item.perilMemo = memo
                item.risk = point
                return item
            }()
            submitInfoCommand.onNext(hiddenPeril)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func refreshSubviews(with attachment: MLTaskAttachment, riskUnit: MLRiskPointDetail) {
        self.riskPoint = riskUnit
        do {
            let unitName = try riskUnit.unitName.unwrap()
            self.riskPointClickView.update(description: unitName)
        } catch { MolueLogger.UIModule.message(error) }
        do {
            let remark = try attachment.remark.unwrap()
            self.reasonRemarkView.updateRemark(with: remark)
        } catch { MolueLogger.UIModule.message(error) }
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
