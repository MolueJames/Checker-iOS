//
//  NoHiddenRiskReusableFooterView.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-22.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon

class NoHiddenRiskReusableFooterView: UICollectionReusableView {

    @IBOutlet weak var taskDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var reasonRemarkView: MLCommonRemarkView! {
        didSet {
            reasonRemarkView.defaultValue(title: "请填写具体该次检查的详情", limit: 100)
        }
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
    }
    
}
