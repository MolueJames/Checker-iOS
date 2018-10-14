//
//  RegisterAccountViewController.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/13.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RegisterAccountPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RegisterAccountViewController: MLBaseViewController, RegisterAccountPagePresentable, RegisterAccountViewControllable {

    var listener: RegisterAccountPresentableListener?
}
