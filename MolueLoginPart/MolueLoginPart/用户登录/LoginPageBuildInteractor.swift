//
//  LoginPageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/9/24.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation
import MolueFoundation
import MolueMediator
import MolueUtilities

protocol MolueLoginPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: LoginPagePresentableListener? {get set}
    func pushToViewController(_ controller: UIViewController?)
}

class MolueLoginPageInteractor: MoluePresenterInteractable, LoginPagePresentableListener, MolueForgetPwdInteractable {
    func backButtonClicked() {
        MolueLogger.UIModule.message("clicked")
    }
    
    func routerToForgetPassword() {
        let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.ForgetPwd)
        let builder: MolueForgetPwdBuildable? = builderFactory.queryBuilder()
        let controller = builder?.build(listener: self)
        self.presenter?.pushToViewController(controller)
    }
    
    typealias Presentable = MolueLoginPagePresentable
    
    weak var presenter: Presentable?
    
    weak var listener: MolueLoginPageInteractable?
    
    required init(presenter: Presentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    func showTest() {
        self.listener?.testFunction()
        self.presenter?.showWarningHUD(text: "xxxxxx")
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

class MolueLoginPageBuilder: MolueComponentBuilder, MolueLoginPageBuildable  {
    
    func build(listener: MolueLoginPageInteractable) -> UIViewController? {
        let controller = LoginPageViewController.initializeFromStoryboard()!
        let interactor = MolueLoginPageInteractor(presenter: controller)
        interactor.listener = listener
        return controller
    }
}

