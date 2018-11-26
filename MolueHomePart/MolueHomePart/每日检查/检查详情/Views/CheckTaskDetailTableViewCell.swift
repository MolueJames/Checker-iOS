//
//  CheckTaskDetailTableViewCell.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit

class CheckTaskDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBAction func successButtonClicked(_ sender: UIButton) {
        self.statusImageView.image = UIImage(named: "molue_check_success")
    }
    @IBAction func failureButtonClicked(_ sender: UIButton) {
        self.statusImageView.image = UIImage(named: "molue_check_failure")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func refreshSubviews(with model: String) {
        self.taskNameLabel.text = model
    }
    
//    override var frame:CGRect{
//        didSet {
//            var new = self.frame
//            new.origin.x += 10
//            new.size.width -= 20
//            new.origin.y += 0
//            new.size.height -= 10
//            super.frame = new
//        }
//    }
}
