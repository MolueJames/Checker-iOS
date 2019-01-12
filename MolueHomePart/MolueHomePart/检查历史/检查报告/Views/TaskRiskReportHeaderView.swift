//
//  TaskRiskReportHeaderView.swift
//  MolueHomePart
//
//  Created by MolueJames on 2019/1/12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import UIKit

class TaskRiskReportHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = MLCommonColor.appDefault
    }
}
