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

public enum EditRiskInfoRrror: LocalizedError {
    case classInvalid
    case pointInvalid
    case levelInvalid
    
    public var errorDescription: String? {
        switch self {
        case .classInvalid:
            return "请选择隐患类别"
        case .pointInvalid:
            return "请选择风险单元"
        case .levelInvalid:
            return "请选择隐患级别"
        }
    }
}

class EditRiskInfoResuableFooterView: UICollectionReusableView {
    private let disposeBag = DisposeBag()
    
    private var riskLevel: PotentialRiskLevel?
    
    private var riskClass: MLRiskClassification?
    
    private var riskPoint: MLRiskPointDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.submitInfoCommand = PublishSubject<MLHiddenPerilItem>()
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
    
    
    
    func queryHiddenPeril() throws -> MLHiddenPerilItem {
        guard let classification = self.riskClass else {
            throw EditRiskInfoRrror.classInvalid
        }
        guard let level = self.riskLevel else {
            throw EditRiskInfoRrror.levelInvalid
        }
        guard let point = self.riskPoint else {
            throw EditRiskInfoRrror.pointInvalid
        }
        let hiddenPeril: MLHiddenPerilItem = {
            let hiddenPeril = MLHiddenPerilItem()
            hiddenPeril.classification = classification
            hiddenPeril.grade = level.toService
            hiddenPeril.risk = point
            return hiddenPeril
        }()
        return hiddenPeril
    }
    
    func refreshSubviews(with riskUnit: MLRiskPointDetail) {
        do {
            self.riskPoint = riskUnit
            let unitName = try riskUnit.unitName.unwrap()
            self.riskPointClickView.update(description: unitName)
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
