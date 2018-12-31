//
//  TaskAttachmentCollectionCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-26.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import Kingfisher
import MolueMediator

class TaskAttachmentCollectionCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var taskImageView: UIImageView!
    
    func refreshSubviews(with attachment: MLAttachmentDetail) {
        self.taskImageView.image = attachment.image
    }
    
    func loadAttachmentURL(with attachment: MLAttachmentDetail) {
        do {
            let path = try attachment.urlPath.unwrap()
            let urlPath = URL(string: path)
            self.taskImageView.kf.indicatorType = .activity
            self.taskImageView.kf.setImage(with: urlPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
