//
//  DangerUnitSectionHeaderView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities

class DangerUnitSectionHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var dangerUnitLabel: UILabel!
    @IBOutlet weak var dangerNumberLabel: UILabel!
    @IBOutlet weak var dangerClassLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
    
    public func refreshSubviews(with model: MLDailyPlanDetailModel) {
        do {
            let risk_unit = try model.risk_unit.unwrap()
            self.dangerUnitLabel.text = risk_unit.unit_name.data()
            self.dangerNumberLabel.text = risk_unit.unit_code.data()
            let category = try risk_unit.category.unwrap()
            self.dangerClassLabel.text = category.title.data()
        } catch { MolueLogger.UIModule.error(error) }
    }
}
