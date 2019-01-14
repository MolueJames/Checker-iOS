//
//  HomeInfoCollectionViewCell.swift
//  MolueHomePart
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import Kingfisher

class HomeInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            imageView.image = UIImage(named: "molue_home_banner")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refreshSubviews(with item: MLAdvertisement) {
        do {
            let path = try item.imageUrl.unwrap()
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: path))
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }

}
