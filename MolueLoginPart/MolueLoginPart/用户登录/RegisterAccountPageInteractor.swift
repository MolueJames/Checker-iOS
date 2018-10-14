//
//  RegisterAccountPageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/13.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol RegisterAccountViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RegisterAccountPagePresentable: MolueInteractorPresentable {
    var listener: RegisterAccountPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RegisterAccountPageInteractor: MoluePresenterInteractable, RegisterAccountRouterInteractable, RegisterAccountPresentableListener {
    
    typealias Presentable = RegisterAccountPagePresentable
    weak var presenter: Presentable?
    
    var viewRouter: RegisterAccountViewableRouting?
    
    weak var listener: RegisterAccountInteractListener?
    
    required init(presenter: Presentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
