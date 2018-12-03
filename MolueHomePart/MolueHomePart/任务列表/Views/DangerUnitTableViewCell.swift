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

    @IBOutlet weak var riskStateLabel: UILabel!
    @IBOutlet weak var riskHeadLabel: UILabel!
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var riskClassLabel: UILabel!
    @IBOutlet weak var riskNameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func refreshSubviews(with model: DangerUnitRiskModel) {
        self.riskHeadLabel.text = model.riskHead
        self.riskLevelLabel.text = model.riskLevel
        self.riskNameLabel.text = model.riskName
        self.riskClassLabel.text = "ABT00002"//model.riskClass
        self.riskStateLabel.text = model.riskStatus
        self.riskStateLabel.textColor = self.queryColor(with: model)
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
