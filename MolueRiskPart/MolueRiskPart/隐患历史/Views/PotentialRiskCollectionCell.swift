//
//  PotentialRiskCollectionCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator
import Kingfisher
import UIKit

class PotentialRiskCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var imageView: UIImageView!
    
    func refreshSubviews(with attachment: MLAttachmentDetail) {
        do {
            let path = try attachment.urlPath.unwrap()
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: path))
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
