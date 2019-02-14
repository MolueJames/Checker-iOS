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
        self.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshSubviews(with item: MLRiskPointDetail) {
        
    }
}
