//
//  MLCommonTitleView.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/7/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import MolueUtilities
public class MLCommonTitleView: UIView {

    lazy private var lineView: UIView! = {
        let internalLineView = UIView()
        self.addSubview(internalLineView)
        internalLineView.snp.makeConstraints({ (make) in
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(MLConfigure.single_line_height)
        })
        return internalLineView
    }()
    
    lazy private var titleLabel: UILabel! = {
        let internalTitleLabel = UILabel()
        self.addSubview(internalTitleLabel)
        internalTitleLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-20)
            make.left.equalTo(20)
            make.top.bottom.equalToSuperview()
        })
        return internalTitleLabel
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateViewElements()
    }
    private func updateViewElements() {
        self.lineView.backgroundColor = MLCommonColor.commonLine
        self.titleLabel.font = .systemFont(ofSize: 16)
        self.titleLabel.textColor = MLCommonColor.titleLabel
    }
    
    public func defaultValue(title: String) {
        self.titleLabel.text = title
    }
}
