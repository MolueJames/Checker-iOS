//
//  TaskCheckDetailCollectionViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import Kingfisher
import UIKit

class TaskCheckDetailCollectionViewCell: UICollectionViewCell {

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
    
}
