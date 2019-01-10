//
//  EditRiskInfoCollectionViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class EditRiskInfoCollectionViewCell: UICollectionViewCell {

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
    
    func refreshSubviews(with attachment: MLAttachmentDetail)  {
        if let path = attachment.urlPath {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: path))
        } else if let image = attachment.image {
            self.imageView.image = image
        }
    }
}
