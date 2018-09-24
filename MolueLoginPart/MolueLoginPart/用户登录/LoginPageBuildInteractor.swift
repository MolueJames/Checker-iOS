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
import ObjectMapper
protocol MolueLoginPagePresentable: MolueInteractorPresentable {
    var listener: LoginPagePresentableListener? {get set}
}

class MolueLoginPageInteractor: MoluePresenterInteractor<MolueLoginPagePresentable>, LoginPagePresentableListener {
    func showTest() {
        self.listener?.testFunction()
    }
    
    var listener: MolueLoginPageInteractable?
    
    override init(presenter: MolueLoginPagePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

class MolueLoginPageBuilder: MolueBaseBuilder, MolueLoginPageBuildable  {
    
    func build(listener: MolueLoginPageInteractable) -> UIViewController? {
        let controller = LoginPageViewController.initializeFromStoryboard()!
        let interactor = MolueLoginPageInteractor(presenter: controller)
        interactor.listener = listener
        return controller
    }
}

