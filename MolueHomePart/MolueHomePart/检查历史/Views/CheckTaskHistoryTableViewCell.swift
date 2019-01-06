//
//  CheckTaskHistoryTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class CheckTaskHistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addLayerShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var checkTaskLabel: UILabel!
    
    @IBOutlet weak var riskCodeLabel: UILabel!
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var taskStateLabel: UILabel!
    
    public func refreshSubviews(with task: MLDailyCheckTask) {
        do {
            let risk = try task.risk.unwrap()
            self.checkTaskLabel.text = risk.unitName.data()
            self.riskCodeLabel.text = risk.unitCode.data()
            self.responseLabel.text = risk.responseUnit.data()
        } catch { MolueLogger.UIModule.message(error) }
        self.refreshStatusLabel(with: task)
    }
    
    public func refreshStatusLabel(with task: MLDailyCheckTask) {
        do {
            let status = try task.status.unwrap()
            let textColor = self.queryColor(with: status)
            self.taskStateLabel.textColor = textColor
            let statusText = self.queryTitle(with: status)
            self.taskStateLabel.text = statusText
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func queryColor(with status: String) -> UIColor {
        switch status {
        case "done":
            return UIColor(hex: 0x33CC33)
        case "risky":
            return UIColor(hex: 0xCC0000)
        default:
            return UIColor(hex: 0xFFCC00)
        }
    }
    
    func queryTitle(with status: String) -> String {
        switch status {
        case "done":
            return "已检查"
        case "risky":
            return "有风险"
        default:
            return "未检查"
        }
    }
    
    override var frame:CGRect{
        didSet {
            var new = self.frame
            new.origin.x += 10
            new.size.width -= 20
            new.origin.y += 15
            new.size.height -= 15
            super.frame = new
        }
    }
}
