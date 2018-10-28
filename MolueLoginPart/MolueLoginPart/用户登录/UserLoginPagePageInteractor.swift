//
//  UserLoginPagePageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol UserLoginPageViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushForgetPasswordViewController()
}

protocol UserLoginPagePagePresentable: MolueInteractorPresentable {
    var listener: UserLoginPagePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class UserLoginPagePageInteractor: MoluePresenterInteractable, UserLoginPageRouterInteractable, UserLoginPagePresentableListener {
    func routerToForgetPassword() {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushForgetPasswordViewController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }

    weak var presenter: UserLoginPagePagePresentable?
    
    var viewRouter: UserLoginPageViewableRouting?
    
    weak var listener: UserLoginPageInteractListener?
    
    required init(presenter: UserLoginPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
