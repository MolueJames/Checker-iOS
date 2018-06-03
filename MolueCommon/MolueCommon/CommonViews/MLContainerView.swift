//
//  MLContainerView.swift
//  MolueCommon
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import MolueUtilities
public class MLContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy private var bottomLineView: UIView! = {
        let bottomLineView = UIView()
        self.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.height.equalTo(MLConfigure.single_line_height)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(20)
        }
        return bottomLineView
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        bottomLineView.backgroundColor = UIColor.init(hex: 0x999999)
    }
}
