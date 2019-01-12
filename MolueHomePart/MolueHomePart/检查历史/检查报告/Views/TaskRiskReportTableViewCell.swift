//
//  RiskInfoTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class TaskRiskReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var riskNumberLabel: UILabel!
    @IBOutlet weak var riskStatusLabel: UILabel!
    @IBOutlet weak var riskChannelLabel: UILabel!
    @IBOutlet weak var riskUnitLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with item: MLHiddenPerilItem) {
        self.riskNumberLabel.text = item.perilId.data()
        self.riskUnitLabel.text = item.risk?.unitName ?? "暂无数据"
        let level = self.queryRiskLevel(with: item.grade)
        self.riskLevelLabel.text = level
        let status = self.queryRiskStatus(with: item.status)
        self.riskStatusLabel.text = status
        self.riskChannelLabel.text = item.classification?.name ?? "暂无数据"
    }
    
    func queryRiskStatus(with status: String?) -> String {
        do {
            switch try status.unwrap() {
            case "created":
                return "已发现"
            case "approved":
                return "已安排"
            case "done":
                return "已整改"
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
    
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 10
            new.size.height -= 10
            super.frame = new
        }
    }
}
