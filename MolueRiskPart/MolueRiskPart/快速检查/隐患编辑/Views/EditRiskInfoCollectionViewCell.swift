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
    
    func refreshSubView(with detail: MLAttachmentDetail) {
        self.imageView.image = detail.image
    }
    
    func refreshSubview(with image: UIImage) {
        self.imageView.image = image
    }
    
}
