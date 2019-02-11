//
//  RiskRectifyTableFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/2/9.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities
import MolueCommon

class RiskRectifyFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var finishDateLabel: UILabel!
    
    @IBOutlet weak var finishDateSwitch: UISwitch!
    
    @IBOutlet weak var budgetRiskClickView: MLCommonClickView! {
        didSet {
            budgetRiskClickView.defaultValue(title: "整改资金:", placeholder: "")
        }
    }
    
    @IBOutlet weak var budgetFromClickView: MLCommonClickView! {
        didSet {
            budgetFromClickView.defaultValue(title: "资金来源:", placeholder: "")
        }
    }
    
    func refreshSubviews(with item: MLHiddenPerilItem) {
        let budget: String = item.rectifyBudget ?? "0.00"
        self.budgetRiskClickView.update(description: budget + "元")
        
        guard let need = item.needRectification else {return}
        let rectify: String? = need ? item.rectifyDate : "暂无截止日期"
        self.finishDateLabel.text = rectify
        self.finishDateSwitch.isOn = need
    }
}
