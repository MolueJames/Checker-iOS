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

class CheckTaskSectionHeaderView: UIView {

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
    
    public func refreshSubviews(with model: MLDailyCheckPlan) {
        do {
            let category = try model.category.unwrap()
            self.dangerClassLabel.text = category.title.data()
        } catch {
            MolueLogger.UIModule.message(error)
        }
        self.dangerUnitLabel.text = model.unitName.data()
        self.dangerNumberLabel.text = model.unitCode.data()
    }
}
