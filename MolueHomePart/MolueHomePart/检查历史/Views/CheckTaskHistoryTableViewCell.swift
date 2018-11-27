//
//  CheckTaskHistoryTableViewCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
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
    
    @IBOutlet weak var taskClassLabel: UILabel!
    
    @IBOutlet weak var riskCheckerLabel: UILabel!
    
    @IBOutlet weak var taskStateLabel: UILabel!
    
    public func refreshSubviews(with item: DangerUnitRiskModel) {
        self.checkTaskLabel.text = item.riskName
        self.taskClassLabel.text = item.riskClass
        self.taskStateLabel.text = item.riskStatus
        self.taskStateLabel.textColor = self.queryColor(with: item)
        self.riskCheckerLabel.text = "张建国"
    }
    
    func queryColor(with item: DangerUnitRiskModel) -> UIColor {
        do {
            switch try item.riskStatus.unwrap() {
            case "已检查":
                return UIColor(hex: 0x33CC33)
            case "有隐患":
                return UIColor(hex: 0xCC0000)
            default:
                return UIColor(hex: 0xFFCC00)
            }
        } catch {
            return UIColor(hex: 0xFFCC00)
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
