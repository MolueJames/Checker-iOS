//
//  HomeInfoTableViewCell.swift
//  MolueHomePart
//
//  Created by James on 2018/5/15.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class HomeInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 0
            new.size.height -= 10
            super.frame = new
        }
    }
}
