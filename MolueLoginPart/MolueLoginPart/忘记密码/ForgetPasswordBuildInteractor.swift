//
//  ForgetPasswordBuildInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/1.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation
import MolueFoundation
import MolueUtilities
import MolueMediator

protocol MolueForgetPwdPresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: ForgetPwdPresentableListener? {get set}
}

class MolueForgetPwdInteractor: MoluePresenterInteractable, ForgetPwdPresentableListener {
    func backButtonClicked() {
        self.listener?.backButtonClicked()
    }
    
    typealias Presentable = MolueForgetPwdPresentable
    
    weak var presenter: Presentable?
    
    weak var listener: MolueForgetPwdInteractable?
    
    required init(presenter: Presentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

class MolueForgetPwdBuilder: MolueComponentBuilder, MolueForgetPwdBuildable  {
    
    func build(listener: MolueForgetPwdInteractable) -> UIViewController? {
        let controller = ForgetPasswordViewController.initializeFromStoryboard()!
        let interactor = MolueForgetPwdInteractor(presenter: controller)
        interactor.listener = listener
        return controller
    }
}

protocol MolueForgetPwdInteractable: class{
    func backButtonClicked()
}

protocol MolueForgetPwdBuildable: class {
    func build(listener: MolueForgetPwdInteractable) -> UIViewController?
}
