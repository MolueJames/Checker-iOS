//
//  RiskInfoTableViewCell.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class PotentialRiskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var riskNumberLabel: UILabel!
    @IBOutlet weak var riskUnitLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusUserLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
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
        self.statusUserLabel.text = status
        let time = self.queryUpdateTime(with: item.updated)
        self.updateTimeLabel.text = time
        let screenName = self.queryUpdateUser(with: item)
        self.usernameLabel.text = screenName
    }
    
    func queryUpdateTime(with time: String?) -> String {
        do {
            let time = try time.unwrap()
            return try time.transfer(to: "yyyy-MM-dd HH:mm")
        } catch { return "暂无数据" }
    }
    
    func queryUpdateUser(with item: MLHiddenPerilItem) -> String {
        do {
            switch try item.status.unwrap() {
            case "created":
                return self.queryScreenName(with: item.createdUser)
            case "approved":
                return self.queryScreenName(with: item.createdUser)
            case "done":
                return self.queryScreenName(with: item.createdUser)
            default:
                return self.queryScreenName(with: item.createdUser)
            }
        } catch { return "暂无数据" }
    }
    
    func queryScreenName(with user: MolueUserInfo?) -> String {
        do {
            let user = try user.unwrap()
            return try user.screenName.unwrap()
        } catch { return "暂无数据" }
    }
    
    func queryRiskStatus(with status: String?) -> String {
        do {
            switch try status.unwrap() {
            case "created":
                return "检查人员"
            case "approved":
                return "安排人员"
            case "done":
                return "整改人员"
            default:
                return "验收人员"
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
