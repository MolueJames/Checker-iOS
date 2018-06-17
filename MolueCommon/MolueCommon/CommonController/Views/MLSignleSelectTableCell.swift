//
//  MLSignleSectionTableCell.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class MLSignleSelectTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let color = UIColor.init(hex: 0x333333).cgColor
        self.layer.borderColor = color
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.1
    }
    
    public func reloadSubviewsWithValue(_ value: MLSingleSelectProtocol) {
        self.titleLabel.text = value.description
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
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var selectImageView: UIImageView!
}
