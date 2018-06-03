//
//  HomeInfoCollectionViewCell.swift
//  MolueHomePart
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import Kingfisher
class HomeInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            let url = URL.init(string: "https://car2.autoimg.cn/cardfs/product/g25/M0A/B4/4D/1024x0_1_q87_autohomecar__ChcCr1qeYluAX2fpAAegIXY-YTA697.jpg")
            imageView.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
