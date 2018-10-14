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
    public var deleteCommand: PublishSubject<MLCommonPhotoCell>?
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.borderWidth = MLConfigure.singleLineHeight
        let color = UIColor.init(hex: 0xCCCCCC)
        self.borderColor = color
    }
    @IBAction private func deleteButtonClicked(_ sender: Any) {
        self.deleteCommand?.onNext(self)
    }
    public func reloadSubviewWithImage(_ image: UIImage) {
        self.imageView.image = image
        self.deleteCommand = PublishSubject<MLCommonPhotoCell>()
    }
}
