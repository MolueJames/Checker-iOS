//
//  RiskDetailSelectTableViewCell.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator
import UIKit

class RiskDetailSelectTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            self.selectImageView.image = UIImage(named: "common_single_select")
        } else {
            self.selectImageView.image = UIImage()
        }
    }
    
    func refreshSubviews(with classification: MLRiskClassification) {
        self.titleLabel.text = classification.name.data()
    }
    
    func refreshSubviews(with riskUnit: MLRiskPointDetail) {
        self.titleLabel.text = riskUnit.unitName.data()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
}
