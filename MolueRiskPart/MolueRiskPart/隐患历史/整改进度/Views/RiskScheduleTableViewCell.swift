//
//  RiskScheduleTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class RiskScheduleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func refreshSubviews(with item: MLPerilRectifyStep) {
        self.titleLabel.text = item.title.data()
        self.titleLabel.setLineSpacing(6)
    }
}
