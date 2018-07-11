//
//  SelfRiskCheckViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/6/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueFoundation
class SelfRiskCheckViewController: MLBaseViewController {
    
    @IBOutlet weak var checkTypeClickView: MLCommonClickView! {
        didSet {
            checkTypeClickView.defaultValue(title: "检查类型", placeholder: "请选择检查类型")
        }
    }
    
    @IBOutlet weak var checkDataClickView: MLCommonClickView! {
        didSet {
            checkDataClickView.defaultValue(title: "检查时间", placeholder: "请选择检查时间")
        }
    }
    
    @IBOutlet weak var checkerNameInputView: MLCommonInputView! {
        didSet {
            checkerNameInputView.defaultValue(title: "检查人员", placeholder: "请填写检查人员姓名")
        }
    }
    
    @IBOutlet weak var riskPlaceClickView: MLCommonClickView! {
        didSet {
            riskPlaceClickView.defaultValue(title: "隐患部位", placeholder: "请选择隐患所在的具体部位")
        }
    }
    
    @IBOutlet weak var riskDescriptionInputView: MLCommonClickView! {
        didSet {
            riskDescriptionInputView.defaultValue(title: "隐患描述", placeholder: "请选择不合格项的描述")
        }
    }
    
    @IBOutlet weak var riskCategoryClickView: MLCommonClickView! {
        didSet {
            riskCategoryClickView.defaultValue(title: "隐患类别", placeholder: "请选择隐患类别")
        }
    }
    
    @IBOutlet weak var riskLevelClickView: MLCommonClickView! {
        didSet {
            riskLevelClickView.defaultValue(title: "隐患级别", placeholder: "请选择隐患级别")
        }
    }
    
    @IBOutlet weak var uploadPhotoView: MLCommonPhotoView! {
        didSet {
            uploadPhotoView.defaultValue(title: "添加隐患照片", list: [UIImage](), count: 4)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelfRiskCheckViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患自查"
    }
}
