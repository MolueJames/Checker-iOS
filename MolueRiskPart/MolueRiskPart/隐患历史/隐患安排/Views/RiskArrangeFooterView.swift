//
//  RiskArrangeFinishFooterView.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/11.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueCommon
import RxSwift
import UIKit

class RiskArrangeFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        let color = MLCommonColor.commonLine.cgColor
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        self.layer.shadowRadius = 0.5;
        self.layer.shadowOpacity = 0.7
    }
    
    var submitCommand = PublishSubject<Void>()
    
    @IBOutlet weak var finishDateClickView: MLCommonClickView! {
        didSet {
            finishDateClickView.defaultValue(title: "截止日期: ", placeholder: "请选择截止日期")
        }
    }
    func updateFinishCommand(with command: PublishSubject<Void>) {
        self.finishDateClickView.clickedCommand = command
    }
    
    func updateFinishDate(with title: String) {
        self.finishDateClickView.update(description: title)
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        self.submitCommand.onNext(())
    }
}
