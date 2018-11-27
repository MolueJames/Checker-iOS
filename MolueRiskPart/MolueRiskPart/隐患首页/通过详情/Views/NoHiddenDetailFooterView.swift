//
//  NoHiddenDetailFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class NoHiddenDetailFooterView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var desciptionLabel: UILabel!
    public func refreshSubviews(with item: TaskSuccessModel) {
        do {
            let detail = try item.detail.unwrap()
            let defaultStr: String = "暂无检查详情描述"
            let description: String = detail.isEmpty ? defaultStr : detail
            let attributedText = NSMutableAttributedString(string: description)
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6 //大小调整
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, description.count))
            self.desciptionLabel.attributedText = attributedText
        } catch {}
    }
    
}
