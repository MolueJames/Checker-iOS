//
//  RiskDetailSectionHeaderView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueCommon

class RiskDetailSectionHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = MLCommonColor.appDefault
    }
    
    func refreshSubviews(with item: MLRiskClassification) {
        self.titleLabel.text = item.name.data()
    }
    
    func refreshSubviews(with item: MLRiskUnitDetail) {
        self.titleLabel.text = item.unitName.data()
    }
}
