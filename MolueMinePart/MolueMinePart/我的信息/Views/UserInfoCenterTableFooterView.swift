//
//  UserInfoCenterTableFooterView.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/12/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift

class UserInfoCenterTableFooterView: UIView {
    
    let logoutCommand = PublishSubject<Void>()

    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        self.logoutCommand.onNext(())
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
