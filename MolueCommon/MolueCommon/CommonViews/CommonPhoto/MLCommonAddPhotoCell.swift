//
//  MLCommonAddPhotoCell.swift
//  MolueCommon
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import RxSwift
class MLCommonAddPhotoCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let color = UIColor.init(hex: 0xCCCCCC)
        self.borderColor = color
        self.borderWidth = MLConfigure.single_line_height
    }
    
    @IBAction private func appendButtonClicked(_ sender: UIButton) {
        self.appendCommand.onNext(())
    }
    public let appendCommand = PublishSubject<Void>()
}
