//
//  DailyCheckTaskHeaderView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import Foundation
import MolueUtilities
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
    
    func refreshSubviews(with model: MLRiskTaskDetailModel) {
        self.dangerReasonLabel.text = model.dangers.data()
        self.dangerReasonLabel.setLineSpace(5)
        self.dependenceLabel.text = model.standards.data()
        self.responseLabel.text = model.unit.data()
        
        let classification: [String]? = model.classification?.compactMap({ item in
            return item.name
        })
        let classificationText = classification?.joined(separator: ", ")
        self.riskClassLabel.text = classificationText.data()
        
        let accident: [String]? = model.accidents?.compactMap({ item in
            return item.name
        })
        let accidentText = accident?.joined(separator: ", ")
        self.accidentLabel.text = accidentText.data()
    }
}
