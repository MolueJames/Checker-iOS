//
//  EditRiskInfoResuableFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon

class EditRiskInfoResuableFooterView: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var riskTypeClickView: MLCommonClickView! {
        didSet {
            riskTypeClickView.defaultValue(title: "隐患类别", placeholder: "请选择隐患类别")
        }
    }
    
    @IBOutlet weak var deadLineClickView: MLCommonClickView! {
        didSet {
            deadLineClickView.defaultValue(title: "整改日期", placeholder: "请选择整改日期")
        }
    }
    
    @IBOutlet weak var riskUnitClickView: MLCommonClickView! {
        didSet {
            riskUnitClickView.defaultValue(title: "风险单元", placeholder: "请选择风险单元")
        }
    }
    @IBOutlet weak var reasonRemarkView: MLCommonRemarkView! {
        didSet {
            reasonRemarkView.defaultValue(title: "请填写具体情况及整改措施方案", limit: 100)
        }
    }
    
}
