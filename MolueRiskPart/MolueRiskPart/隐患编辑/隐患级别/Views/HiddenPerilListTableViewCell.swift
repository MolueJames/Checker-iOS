//
//  HiddenPerilListTableViewCell.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class HiddenPerilListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            self.selectImageView.image = UIImage(named: "risk_detail_selected")
        } else {
            self.selectImageView.image = UIImage()
        }
    }
    
    func refreshSubviews(with item: PotentialRiskLevel) {
        self.titleLabel.text = item.description
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
    
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
