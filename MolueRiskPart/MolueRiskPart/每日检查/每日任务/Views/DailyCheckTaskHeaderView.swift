//
//  DailyCheckTaskHeaderView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit

class DailyCheckTaskHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(hex: 0x1B82D2)
    }
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var dangerReasonLabel: UILabel!
    func refreshSubviews(with model: String) {
        self.dangerReasonLabel.text = model
        self.testLabel.text = model
    }
}
