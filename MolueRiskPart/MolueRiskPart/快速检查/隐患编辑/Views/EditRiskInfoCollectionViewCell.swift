//
//  EditRiskInfoCollectionViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
class EditRiskInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addLayerShadow()
    }
    
    func reloadSubView(with image: UIImage) {
        self.imageView.image = image
    }
}
