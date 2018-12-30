//
//  TaskAttachmentCollectionCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-26.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import Kingfisher
import MolueMediator

class TaskAttachmentCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var taskImageView: UIImageView!
    
    func refreshSubviews(with detail: MLAttachmentDetail) {
        if let urlPath = detail.urlPath {
            let url = URL(string: urlPath)
            self.taskImageView.kf.setImage(with: url)
        } else {
            self.taskImageView.image = detail.image
        }
    }
}
