//
//  CheckTaskHistoryCalendarCell.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-03.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueCommon
import JTAppleCalendar

class CheckTaskHistoryCalendarCell: JTAppleCell {
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    
    private var cellState: CellState?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.statusView.layer.cornerRadius = 1.5
    }
    
    func refreshSubviews(with state: CellState) {
        self.isUserInteractionEnabled = false
        self.statusView.backgroundColor = UIColor(hex: 0xCCCCCC)
        self.numberLabel.text = state.text
        let isThisMonth = state.dateBelongsTo == .thisMonth
        self.refreshSubviews(with: isThisMonth)
        self.cellState = state
    }
    
    func refreshSubviews(with taskHistory: MLCheckTaskHistory) {
        do {
            self.isUserInteractionEnabled = true
            let tasks = try taskHistory.tasks.unwrap()
            let pending = tasks.contains(where: { (task) -> Bool in
                return task.status == "pending"
            })
            let isRisky = tasks.contains(where: { (task) -> Bool in
                return task.status == "risky"
            })
            let isDone = tasks.contains(where: { (task) -> Bool in
                return task.status == "done"
            })
            let color = self.queryColor(with: pending, isRisky: isRisky, isDone: isDone)
            self.statusView.backgroundColor = color
        } catch { MolueLogger.UIModule.message(error) }
    }
    
    func queryColor(with pending: Bool, isRisky: Bool, isDone: Bool) -> UIColor {
        if isRisky { return UIColor(hex: 0xCC0000) }
        if pending { return UIColor(hex: 0xFFCC00) }
        if isDone { return UIColor(hex: 0x33CC33) }
        return UIColor(hex: 0xCCCCCC)
    }
    
    func refreshSubviews(with isThisMonth: Bool) {
        let textColor = isThisMonth ? MLCommonColor.appDefault : MLCommonColor.commonLine
        self.numberLabel.textColor = textColor
        self.statusView.isHidden = !isThisMonth
    }
    
    
    func updateSubviews(with isSelected: Bool) {
        
    }
}
