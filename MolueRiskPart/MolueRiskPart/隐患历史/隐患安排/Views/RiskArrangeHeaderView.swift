//
//  PotentialRiskHeaderView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon
import RxSwift
import UIKit

class RiskArrangeHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var moreCommand = PublishSubject<Void>()
    
    @IBAction func moreButtonClicked(_ sender: UIButton) {
        self.moreCommand.onNext(())
    }
    
    func updateDetailCommand(with command: PublishSubject<Void>) {
        self.moreCommand = command
    }
    
    @IBOutlet weak var riskNumberLabel: UILabel!
    
    @IBOutlet weak var levelTitleView: MLCommonClickView!
    
    @IBOutlet weak var classTitleView: MLCommonClickView!
    
    @IBOutlet weak var pointTitleView: MLCommonClickView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func refreshSubviews(with item: MLHiddenPerilItem)  {
        let level: String = self.queryRiskLevel(with: item.grade)
        levelTitleView.defaultValue(title: "隐患级别", placeholder: level)
        
        let riskClass: String = item.classification?.name ?? "暂无数据"
        classTitleView.defaultValue(title: "隐患分类", placeholder: riskClass)
        
        let riskUnit: String = item.risk?.unitName ?? "暂无数据"
        pointTitleView.defaultValue(title: "隐患部位", placeholder: riskUnit)
        
        self.riskNumberLabel.text = item.perilId.data()
    }
}
