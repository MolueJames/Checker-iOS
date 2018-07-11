
//
//  MLCommonRemarkView.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/7/8.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
public class MLCommonRemarkView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
    }
    
    private func updateViewElements() {
        self.placeholderLable.text = "备注说明"
        
    }
    lazy private var placeholderLable: UILabel! = {
        let internalPlaceholderLabel = UILabel()
        self.addSubview(internalPlaceholderLabel)
        internalPlaceholderLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(15)
            make.left.equalTo(20)
        })
        return internalPlaceholderLabel
    }()
    
    lazy private var remarkTextView: UITextView! = {
        let internalRemarkTextView = UITextView()
        return internalRemarkTextView
    }()
    
    lazy private var numberLabel: UILabel! = {
        let internalNumberLabel = UILabel()
        return internalNumberLabel
    }()
}
