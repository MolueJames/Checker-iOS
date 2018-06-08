//
//  MLCommonPhotoCell.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit

class MLCommonPhotoCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderWidth = 1
        let color = UIColor.init(hex: 0x999999).cgColor
        containerView.layer.borderColor = color
    }

}
