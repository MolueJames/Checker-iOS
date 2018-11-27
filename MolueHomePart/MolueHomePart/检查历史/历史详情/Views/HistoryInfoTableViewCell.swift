//
//  HistoryInfoTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class HistoryInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var measureNameLabel: UILabel!
    public func refreshSubviews(with item: RiskMeasureModel) {
        let name = item.measureState ? "molue_check_success" : "molue_check_failure"
        self.statusImageView.image = UIImage(named: name)
        self.measureNameLabel.text = item.measureName
    }
}
