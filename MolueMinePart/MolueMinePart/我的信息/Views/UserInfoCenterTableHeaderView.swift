//
//  MineInfoTableHeaderView.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/7/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator

class UserInfoCenterTableHeaderView: UIView {
    func refreshSubviews(with user: MolueUserInfo) {
        self.usernameLabel.text = user.screenName.data()
        self.userRoleLabel.text = user.userRole.data()
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
}
