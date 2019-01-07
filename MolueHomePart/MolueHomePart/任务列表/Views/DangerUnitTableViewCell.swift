//
//  DangerUnitTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator

class DangerUnitTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    @IBOutlet weak var riskStateLabel: UILabel! {
        didSet {
            riskStateLabel.layer.masksToBounds = true
            riskStateLabel.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var riskHeadLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var riskClassLabel: UILabel!
    @IBOutlet weak var riskNameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with model: MLDailyCheckTask) {
        do {
            let risk = try model.risk.unwrap()
            self.riskHeadLabel.text = risk.person.data()
            self.riskLevelLabel.text = queryLevel(risk.level)
            self.riskNameLabel.text = risk.unitName.data()
            self.riskClassLabel.text = risk.unitCode.data()
        } catch {
            MolueLogger.UIModule.message(error)
        }
        
        self.riskStateLabel.text = queryStatus(model.status)
        self.riskStateLabel.backgroundColor = queryColor(model.status)
    }
    
    private func queryStatus(_ status: String?) -> String {
        switch status {
        case "pending":
            return "未检查"
        case "done":
            return "已检查"
        default:
            return "有风险"
        }
    }
    
    private func queryLevel(_ level: String?) -> String {
        switch level {
        case "normal":
            return "一般风险"
        default:
            return "较低风险"
        }
    }
    
    
    private func queryColor(_ status: String?) -> UIColor {
        switch status {
        case "pending":
            return UIColor(hex: 0xFFCC00)
        case "done":
            return UIColor(hex: 0x33CC33)
        default:
            return UIColor(hex: 0xCC0000)
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
