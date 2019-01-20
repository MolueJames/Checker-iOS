//
//  RiskArrangeSectionView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/19.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import UIKit

class RiskArrangeSectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func refreshSubviews(with title: String) {
        self.titleLabel.text = title
    }
}
