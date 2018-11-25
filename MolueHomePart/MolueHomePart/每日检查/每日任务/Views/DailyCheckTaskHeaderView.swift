//
//  DailyCheckTaskHeaderView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class DailyCheckTaskHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     @IBOutlet weak var riskReasonLabel: UILabel!
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
    
    @IBOutlet weak var dangerReasonLabel: UILabel!
    @IBOutlet weak var accidentLabel: UILabel!
    @IBOutlet weak var dependenceLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var riskClassLabel: UILabel!
    
    func refreshSubviews(with model: DangerUnitRiskModel) {
        dangerReasonLabel.text = model.riskReason
        accidentLabel.text = model.accidentType
        dependenceLabel.text = model.dependence
        responseLabel.text = model.responseUnit
        riskClassLabel.text = model.riskClass
    }
}
