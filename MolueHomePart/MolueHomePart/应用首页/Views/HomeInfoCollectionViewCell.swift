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
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refreshSubviews(with item: MLAdvertisement) {
        guard let content = item.content else { return }
        do {
            let path = try content.imageUrl.unwrap()
            self.imageView.kf.setImage(with: URL(string: path))
            self.imageView.kf.indicatorType = .activity
        } catch {
            MolueLogger.UIModule.message(error)
        }
        do {
            let message = try content.title.unwrap()
            self.titleLabel.text = message
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }

}
