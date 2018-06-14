//
//  MLSelectedTableViewCell.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/10.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class MLSelectedTableViewCell: UITableViewCell {
    private var isDefault = false
    public func reloadSubviewsWithValue(_ value: MLSelectedTableViewModel) {
        self.titleLabel.text = value.title
        self.isDefault = value.selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let imageName = self.isDefault ? "common_select_default" : "common_select_selected"
            self.selectImageView.image = UIImage(named: imageName)
        } else {
            self.selectImageView.image = UIImage(named: "common_select_unselect")
        }
        // Configure the view for the selected state
    }
    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    
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
