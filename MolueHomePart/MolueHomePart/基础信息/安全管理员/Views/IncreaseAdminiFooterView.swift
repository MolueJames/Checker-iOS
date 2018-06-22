//
//  AddAdministratorFooterView.swift
//  MolueHomePart
//
//  Created by James on 2018/6/4.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
class IncreaseAdminiFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let addControlCommand = PublishSubject<Void>()
    
    private lazy var addAdministratorControl: UIControl = {
        let control = UIControl()
        self.doBespreadOn(control)
        return control
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDefalutShadow()
        addAdministratorControl.addTarget(self, action: #selector(addControlClicked), for: .touchUpInside)
    }
    
    @IBAction private func addControlClicked(_ sender: UIControl) {
        self.addControlCommand.onNext(())
    }
}
