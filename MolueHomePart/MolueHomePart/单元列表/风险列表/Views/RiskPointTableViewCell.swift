//
//  RiskPointTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2019/2/12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class RiskPointTableViewCell: UITableViewCell {

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
    
    func refreshSubviews(with item: MLRiskPointDetail) {
        self.riskHeadLabel.text = item.person
        self.riskNameLabel.text = item.unitName
        let riskLevel = self.queryLevel(item.level)
        self.riskLevelLabel.text = riskLevel
        self.riskClassLabel.text = item.unitCode
    }
    
    private func queryLevel(_ level: String?) -> String {
        switch level {
        case "normal":
            return "一般风险"
        default:
            return "较低风险"
        }
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
