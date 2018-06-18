//
//  MLCommonPhotoCell.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
class MLCommonPhotoCell: UICollectionViewCell {
    public let deleteCommand = PublishSubject<Void>()
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderWidth = MLConfigure.single_line_height
        let color = UIColor.init(hex: 0xCCCCCC)
        self.borderColor = color
    }
    @IBAction private func deleteButtonClicked(_ sender: Any) {
        self.deleteCommand.onNext(())
    }
    public func reloadSubviewWithImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
