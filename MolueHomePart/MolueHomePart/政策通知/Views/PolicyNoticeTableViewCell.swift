//
//  PolicyNoticeTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/7/6.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class PolicyNoticeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    func refreshSubviews(with item: MLPolicyNoticeModel) {
        guard let notification = item.notification else {return}
        self.titileLabel.text = notification.title.data()
        self.statusLabel.text = item.signatureTime.data()
        self.updatedLabel.text = item.signatureTime.data()
        self.publishLabel.text = notification.createUser.data()
    }
}
