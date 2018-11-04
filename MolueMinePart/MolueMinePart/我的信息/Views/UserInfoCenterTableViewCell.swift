//
//  MineInfoTableViewCell.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class UserInfoCenterTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var centerDetailLabel: UILabel!
    
    @IBOutlet weak var centerInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshSubviews(with model: UserInfoCenterMethod) {
        let value = model.toMethodDetail()
        self.centerDetailLabel.text = value.detail
        self.centerInfoLabel.text = value.name
        self.iconImageView.image = UIImage.init(named: value.image)
    }
    
}
