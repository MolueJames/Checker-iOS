//
//  CheckTaskHistoryCalendarCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-03.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import JTAppleCalendar

class CheckTaskHistoryCalendarCell: JTAppleCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    private var cellState: CellState?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func refreshSubviews(with state: CellState, model: String) {
        if (state.dateBelongsTo == .thisMonth) {
            self.numberLabel.text = state.text
            self.backgroundColor = MLCommonColor.appDefault
            self.isUserInteractionEnabled = true
        } else {
            self.numberLabel.text = ""
            self.backgroundColor = .clear
            self.isUserInteractionEnabled = false
        }
        self.cellState = state
    }

    func updateSubviews(with isSelected: Bool) {
        switch isSelected {
        case true:
            dump(isSelected)
        case false:
            dump(isSelected)
        }
    }
}
