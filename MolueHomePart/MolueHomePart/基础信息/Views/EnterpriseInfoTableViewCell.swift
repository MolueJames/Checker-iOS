//
//  EnterpriseInfoTableViewCell.swift
//  MolueHomePart
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class EnterpriseInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = 22.5
            iconImageView.layer.masksToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 3
        self.contentView.layer.masksToBounds = true
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
    func setEnterpriseInfoModel(_ model: EnterpriseInfoModel) {
        iconImageView.backgroundColor = model.color
        iconImageView.image = UIImage(named: model.imageName)
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
    }
}
