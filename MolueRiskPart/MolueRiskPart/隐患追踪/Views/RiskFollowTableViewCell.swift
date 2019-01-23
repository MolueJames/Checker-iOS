//
//  RiskFollowTableViewCell.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-22.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueUtilities
import MolueMediator

enum RiskFollowPosition {
    case upside
    case middle
    case bottom
    
    public static func create(with index: Int, max: Int) -> RiskFollowPosition {
        if index == max { return .bottom }
        if index == 0 { return .upside }
        return .middle
    }
}

class RiskFollowTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.statusView.layer.cornerRadius = 8.5
    }

    @IBOutlet weak var upsideView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    
    @IBOutlet weak var dateTitleLabel: UILabel!
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshSubviews(with item: MLHiddenPerilAction, position: RiskFollowPosition) {
        self.nameLabel.text = item.actionUser?.screenName ?? "暂未执行"
        self.dateLabel.text = self.queryDate(with: item.actionTime)
        let action = self.queryAction(with: item.action)
        self.statusLabel.text = action
        let status = self.queryStatus(with: item.action)
        self.nameTitleLabel.text = "\(status)人员:"
        self.dateTitleLabel.text = "\(status)时间:"
        self.refreshSubviews(with: position)
        self.updateTextColor(with: item)
    }
    
    func updateTextColor(with item: MLHiddenPerilAction) {
        let isAction: Bool = item.actionId.isSome()
        let defaults: UIColor = MLCommonColor.commonLine
        let actioned: UIColor = MLCommonColor.appDefault
        let color = isAction ? actioned : defaults
        self.statusView.backgroundColor = color
        self.statusLabel.textColor = color
    }
    
    func queryDate(with date: String?) -> String {
        do {
            let format: String = "yyyy-MM-dd hh:mm:ss"
            return try date.unwrap().transfer(to: format)
        } catch { return "暂未执行" }
    }
    
    func refreshSubviews(with position: RiskFollowPosition) {
        switch position {
        case .upside:
            self.upsideView.isHidden = true
            self.bottomView.isHidden = false
        case .middle:
            self.upsideView.isHidden = false
            self.bottomView.isHidden = false
        case .bottom:
            self.upsideView.isHidden = false
            self.bottomView.isHidden = true
        }
    }
    
    func queryAction(with action: String?) -> String? {
        do {
            switch try action.unwrap() {
            case "approved":
                return "已安排"
            case "done":
                return "已完成"
            case "verified":
                return "已验收"
            default:
                return "已登记"
            }
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryStatus(with action: String?) -> String {
        do {
            switch try action.unwrap() {
            case "approved":
                return "安排"
            case "done":
                return "完成"
            case "verified":
                return "验收"
            default:
                return "登记"
            }
        } catch { return "" }
    }
}
