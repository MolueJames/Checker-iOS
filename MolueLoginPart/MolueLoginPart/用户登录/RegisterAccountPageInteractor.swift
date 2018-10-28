//
//  RegisterAccountPageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/26.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator

protocol RegisterAccountViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RegisterAccountPagePresentable: MolueInteractorPresentable {
    var listener: RegisterAccountPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RegisterAccountPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RegisterAccountPagePresentable?
    
    var viewRouter: RegisterAccountViewableRouting?
    
    weak var listener: RegisterAccountInteractListener?
    
    required init(presenter: RegisterAccountPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RegisterAccountPageInteractor: RegisterAccountRouterInteractable {
    
}

extension RegisterAccountPageInteractor: RegisterAccountPresentableListener {
    
}
