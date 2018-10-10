//
//  LoginPageBuilderRouter.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/5.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation
import MolueFoundation
import MolueMediator
import MolueUtilities

protocol MolueLoginRoutingInteractable: MolueForgetPwdInteractable {
    var listener: MolueLoginPageInteractable? {get set}
    var viewRouter: MolueLoginPageViewRouting? {get set}
}

protocol MolueLoginPageControllerable: class {
    
}


class MolueLoginPageRouter: MolueViewableRouting, MolueLoginPageViewRouting {
    typealias Interactable = MolueLoginRoutingInteractable
    typealias Controllerable = MolueLoginPageControllerable
    
    weak var interactor: Interactable?
    weak var controller: Controllerable?
    
    required init(interactor: Interactable, controller: Controllerable) {
        self.controller = controller
        self.interactor = interactor
    }
    
    func pushToForgetPassword() {
        let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.ForgetPwd)
        let builder: MolueForgetPwdBuildable? = builderFactory.queryBuilder()
        let controller = builder?.build(listener: self.interactor!)
        MoluePageNavigator().pushViewController(controller!)
    }
}

class MolueLoginPageBuilder: MolueComponentBuilder, MolueLoginPageBuildable  {
    
    func build(listener: MolueLoginPageInteractable) -> UIViewController? {
        let controller = LoginPageViewController.initializeFromStoryboard()!
        let interactor = MolueLoginPageInteractor(presenter: controller)
        let router = MolueLoginPageRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        interactor.viewRouter = router
        return controller
    }
}
