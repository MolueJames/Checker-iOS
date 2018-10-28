//
//  ForgetPasswordTableViewCell.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/26.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueCommon

class ForgetPasswordTableViewCell: UITableViewCell {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshSubviews(with item: String) {
        self.textLabel?.text = item
    }
}

