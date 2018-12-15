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
    
    public func refreshSubviews(with model: MLRiskTaskDetailModel) {
        self.riskHeadLabel.text = model.person.data()
        self.riskLevelLabel.text = model.level.description
        self.riskNameLabel.text = model.name.data()
        self.riskClassLabel.text = model.code.data()
        self.riskStateLabel.text = model.status.data()
        let color = self.queryColor(with: model.status)
        self.riskStateLabel.backgroundColor = color
    }
    
    private func queryLevel(_ level: String?) -> String {
        do {
            switch try level.unwrap() {
            case "normal":
                return "一般风险"
            default:
                return "较低风险"
            }
        } catch {return "暂无数据"}
    }
    
    
    func queryColor(with item: String?) -> UIColor {
        do {
            switch try item.unwrap() {
            case "valid":
                return UIColor(hex: 0x33CC33)
            case "有隐患":
                return UIColor(hex: 0xCC0000)
            default:
                return UIColor(hex: 0xFFCC00)
            }
        } catch { return UIColor.white }
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
