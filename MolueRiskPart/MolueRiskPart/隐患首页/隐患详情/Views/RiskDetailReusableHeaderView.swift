//
//  RiskDetailReusableHeaderView.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-22.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueMediator

class RiskDetailReusableHeaderView: UICollectionReusableView {

    @IBOutlet weak var statusTitleView: MLCommonClickView!
    
    @IBOutlet weak var channelTitleView: MLCommonClickView!
    
    @IBOutlet weak var levelTitleView: MLCommonClickView!
    
    @IBOutlet weak var classTitleView: MLCommonClickView!
    
    @IBOutlet weak var RiskUnitTitleView: MLCommonClickView!
    
    @IBOutlet weak var checkedDateView: MLCommonClickView!
    
    @IBOutlet weak var finishDateView: MLCommonClickView!
    
    @IBOutlet weak var personTitleView: MLCommonClickView!
    
    @IBOutlet weak var riskDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refreshSubviews(with model: PotentialRiskModel) {
        let status: String = model.status?.description ?? "暂无数据"
        statusTitleView.defaultValue(title: "隐患状态", placeholder: status)
        let level: String = model.level?.description ?? "暂无数据"
        levelTitleView.defaultValue(title: "隐患级别", placeholder: level)
        let riskClass: String = model.riskClass ?? "暂无数据"
        classTitleView.defaultValue(title: "隐患分类", placeholder: riskClass)
        let riskUnit: String = model.riskUnit ?? "暂无数据"
        RiskUnitTitleView.defaultValue(title: "隐患部位", placeholder: riskUnit)
        let checked: String = model.checkedDate ?? "暂无数据"
        checkedDateView.defaultValue(title: "检查时间", placeholder: checked)
        let finishDate: String = model.finishDate ?? "暂无数据"
        finishDateView.defaultValue(title: "整改日期", placeholder: finishDate)
        let channel: String = model.channel?.description ?? "暂无数据"
        channelTitleView.defaultValue(title: "检查类型", placeholder: channel)
        let person: String = model.personDetail ?? "暂无数据"
        personTitleView.defaultValue(title: "检查人员", placeholder: person)
        let description: String = model.riskDetail ?? "暂无数据"
        let attributedText = NSMutableAttributedString(string: description)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 //大小调整
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, description.count))
        self.riskDescLabel.attributedText = attributedText
    }
    
    
}
