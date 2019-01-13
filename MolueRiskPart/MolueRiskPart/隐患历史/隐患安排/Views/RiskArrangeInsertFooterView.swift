//
//  RiskArrangeInsertFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import UIKit

class RiskArrangeInsertFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var remarkView: MLCommonRemarkView! {
        didSet {
            remarkView.defaultValue(title: "请填写整改步骤", limit: 150)
        }
    }
    
}
