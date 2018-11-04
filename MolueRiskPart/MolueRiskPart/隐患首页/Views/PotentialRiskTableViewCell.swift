//
//  RiskInfoTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class PotentialRiskTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
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
    
    public func update(title: String) {
        self.titleLabel.text = title
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
