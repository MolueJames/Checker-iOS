//
//  CheckTaskDetailTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities

class CheckTaskDetailTableViewCell: UITableViewCell {

    public var updateBlock: ((RiskMeasureModel, IndexPath) -> Void)?
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    private var measureItem: RiskMeasureModel?
    
    private var currentIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBAction func successButtonClicked(_ sender: UIButton) {
        self.statusImageView.image = UIImage(named: "molue_check_success")
        do {
            let item = try self.measureItem.unwrap()
            item.measureState = true
            let successBlock = try self.updateBlock.unwrap()
            let indexPath = try self.currentIndexPath.unwrap()
            successBlock(item, indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    @IBAction func failureButtonClicked(_ sender: UIButton) {
        self.statusImageView.image = UIImage(named: "molue_check_failure")
        do {
            let item = try self.measureItem.unwrap()
            item.measureState = false
            let failureBlock = try self.updateBlock.unwrap()
            let indexPath = try self.currentIndexPath.unwrap()
            failureBlock(item, indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func refreshSubviews(with model: RiskMeasureModel, indexPath: IndexPath) {
        self.measureItem = model
        self.currentIndexPath = indexPath
        self.taskNameLabel.text = model.measureName
    }
}
