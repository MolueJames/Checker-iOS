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

protocol MolueLoginPageViewRouting: class {
    func pushToForgetPassword()
}

class MolueLoginPageInteractor: MoluePresenterInteractable, LoginPagePresentableListener, MolueLoginRoutingInteractable {
    typealias Presentable = MolueLoginPagePresentable
    
    var viewRouter: MolueLoginPageViewRouting?
    
    weak var presenter: Presentable?
    
    weak var listener: MolueLoginPageInteractable?
    
    func backButtonClicked() {
        MolueLogger.UIModule.message("clicked")
    }
    
    func routerToForgetPassword() {
        self.viewRouter?.pushToForgetPassword()
    }
    
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




