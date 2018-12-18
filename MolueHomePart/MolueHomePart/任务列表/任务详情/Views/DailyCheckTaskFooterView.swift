//
//  DailyCheckSectionFooterView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class DailyCheckTaskFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var riskRemarkLabel: UILabel!
    
    @IBOutlet weak var riskHeadLabel: UILabel!
    
    @IBOutlet weak var headPhoneLabel: UILabel!
    
    public func refreshSubviews(with model: MLRiskTaskDetailModel) {
        self.headPhoneLabel.text = model.phone.data()
        self.riskHeadLabel.text = model.person.data()
        self.riskRemarkLabel.text = model.remark.data()
    }
}
