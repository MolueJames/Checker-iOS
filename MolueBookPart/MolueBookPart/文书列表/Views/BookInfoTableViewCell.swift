//
//  BookInfoTableViewCell.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/7/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class BookInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setDefalutShadow()
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
            new.origin.y += 10
            new.size.height -= 10
            super.frame = new
        }
    }
}
