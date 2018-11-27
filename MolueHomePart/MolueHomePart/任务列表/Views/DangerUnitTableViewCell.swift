//
//  DangerUnitTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class DangerUnitTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    @IBOutlet weak var riskHeadLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var riskClassLabel: UILabel!
    @IBOutlet weak var riskNameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with model: DangerUnitRiskModel) {
        self.riskHeadLabel.text = model.riskHead
        self.riskLevelLabel.text = model.riskLevel
        self.riskNameLabel.text = model.riskName
        self.riskClassLabel.text = model.riskClass
    }
    
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 15
            new.size.height -= 15
            super.frame = new
        }
    }
}
