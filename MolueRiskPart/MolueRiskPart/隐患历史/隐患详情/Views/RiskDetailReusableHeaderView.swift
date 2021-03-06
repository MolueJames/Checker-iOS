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
    
    @IBOutlet weak var riskNumberView: MLCommonClickView!
    
    @IBOutlet weak var levelTitleView: MLCommonClickView!
    
    @IBOutlet weak var classTitleView: MLCommonClickView!
    
    @IBOutlet weak var pointTitleView: MLCommonClickView!
    
    @IBOutlet weak var checkedDateView: MLCommonClickView!
    
    @IBOutlet weak var personTitleView: MLCommonClickView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func refreshSubviews(with item: MLHiddenPerilItem) {
        let status: String = self.queryRiskStatus(with: item.status)
        statusTitleView.defaultValue(title: "隐患状态", placeholder: status)
        
        let level: String = self.queryRiskLevel(with: item.grade)
        levelTitleView.defaultValue(title: "隐患级别", placeholder: level)
        
        let riskClass: String = item.classification?.name ?? "暂无数据"
        classTitleView.defaultValue(title: "隐患分类", placeholder: riskClass)
        
        let riskPoint: String = item.risk?.unitName ?? "暂无数据"
        pointTitleView.defaultValue(title: "隐患部位", placeholder: riskPoint)
        
        let riskNumber: String = item.perilId.data()
        riskNumberView.defaultValue(title: "隐患编号", placeholder: riskNumber)
        
        let person: String = item.createdUser?.screenName ?? "暂无数据"
        personTitleView.defaultValue(title: "检查人员", placeholder: person)
        
        let created: String = self.queryCreatedTime(with: item.created)
        checkedDateView.defaultValue(title: "检查时间", placeholder: created)
    }
    
    func queryRiskStatus(with status: String?) -> String {
        do {
            switch try status.unwrap() {
            case "created":
                return "已登记"
            case "approved":
                return "已安排"
            case "done":
                return "已完成"
            default:
                return "已验收"
            }
        } catch {return "暂无数据"}
    }
    
    func queryRiskLevel(with level: String?) -> String {
        do {
            switch try level.unwrap() {
            case "large":
                return "重大事故隐患"
            case "normal":
                return "一般事故隐患"
            case "high":
                return "较高事故隐患"
            default:
                return "较低事故隐患"
            }
        } catch {return "暂无数据"}
    }
    
    func queryCreatedTime(with time: String?) -> String {
        do {
            let format: String = "yyyy-MM-dd HH:mm"
            return try time.unwrap().transfer(to: format)
        } catch {return "暂无数据"}
    }
}
