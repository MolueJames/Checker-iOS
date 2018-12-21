//
//  DailyCheckTaskTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class DailyCheckTaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func refreshSubviews(with model: MLRiskUnitSolution) {
        self.titleLabel.text = model.title
    }
    
}
