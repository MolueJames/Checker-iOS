//
//  RiskArrangeTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit

class RiskArrangeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.size.height -= 10
            super.frame = new
        }
    }
}
