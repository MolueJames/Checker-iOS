//
//  RiskInfoTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class PotentialRiskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var riskNumberLabel: UILabel!
    @IBOutlet weak var riskStatusLabel: UILabel!
    @IBOutlet weak var riskChannelLabel: UILabel!
    @IBOutlet weak var riskUnitLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func refreshSubviews(with model: PotentialRiskModel, index: Int) {
        self.riskNumberLabel.text = "BER200000\(index)"
        self.riskUnitLabel.text = model.riskUnit ?? "暂无数据"
        self.riskLevelLabel.text = model.level?.description ?? "暂无数据"
        self.riskStatusLabel.text = model.status?.description ?? "暂无数据"
        self.riskChannelLabel.text = model.channel?.description ?? "暂无数据"
    }
    
    public func refreshSubviews(with model: MLHiddenPerilItem) {
        self.riskNumberLabel.text = model.perilId.data()
//        self.riskUnitLabel.text =
    }
    
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 10
            new.size.height -= 10
            super.frame = new
        }
    }
}
