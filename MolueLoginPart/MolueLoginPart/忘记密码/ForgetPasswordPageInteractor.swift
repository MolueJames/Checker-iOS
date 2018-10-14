//
//  ForgetPasswordPageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol ForgetPasswordViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol ForgetPasswordPagePresentable: MolueInteractorPresentable {
    var listener: ForgetPasswordPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class ForgetPasswordPageInteractor: MoluePresenterInteractable, ForgetPasswordRouterInteractable, ForgetPasswordPresentableListener {
    
    typealias Presentable = ForgetPasswordPagePresentable
    weak var presenter: Presentable?
    
    var viewRouter: ForgetPasswordViewableRouting?
    
    weak var listener: ForgetPasswordInteractListener?
    
    required init(presenter: Presentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
