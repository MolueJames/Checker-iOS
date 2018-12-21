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
    
    public func refreshSubviews(with model: MLRiskDetailUnit) {
        self.headPhoneLabel.text = model.contact.data()
        self.riskHeadLabel.text = model.person.data()
        let defaultRemark = "暂无该风险点的其他的说明"
        do {
            let remark = try model.remark.unwrap()
            let title = remark.isEmpty ? defaultRemark : remark
            self.riskRemarkLabel.text = title
        } catch {
            self.riskRemarkLabel.text = defaultRemark
        }
        self.riskRemarkLabel.setLineSpacing(3)
    }
}
