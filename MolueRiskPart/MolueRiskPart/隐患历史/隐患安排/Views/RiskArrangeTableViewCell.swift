//
//  RiskArrangeTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class RiskArrangeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    func refreshSubviews(with item: String) {
        self.titleLabel.text = item
        self.titleLabel.setLineSpacing(6)
    }
    
    func refreshSubviews(with item: MLPerilSituation) {
        self.titleLabel.text = item.content.data()
        self.titleLabel.setLineSpacing(6)
    }
}
