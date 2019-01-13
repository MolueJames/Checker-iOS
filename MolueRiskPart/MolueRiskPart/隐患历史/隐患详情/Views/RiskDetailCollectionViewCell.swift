//
//  RiskDetailCollectionViewCell.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-22.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit

class RiskDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addLayerShadow()
    }
    
    public func refreshSubviews(with path: String) {
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: URL(string: path))
    }

}
