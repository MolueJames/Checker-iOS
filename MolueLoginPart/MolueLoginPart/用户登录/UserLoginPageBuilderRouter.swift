//
//  UserLoginPageBuilderRouter.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol UserLoginPageRouterInteractable: ForgetPasswordInteractListener {
    var viewRouter: UserLoginPageViewableRouting? { get set }
    var listener: UserLoginPageInteractListener? { get set }
}

protocol UserLoginPageViewControllable: class {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class UserLoginPageViewableRouter: MolueViewableRouting, UserLoginPageViewableRouting {
    func pushForgetPasswordViewController() {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Login>(.ForgetPwd)
            let builder: ForgetPasswordComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: self.interactor.unwrap())
            MoluePageNavigator().pushViewController(controller)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    typealias Interactable = UserLoginPageRouterInteractable
    weak var interactor: Interactable?
    
    typealias Controllable = UserLoginPageViewControllable
    weak var controller: Controllable?
    
    @discardableResult
    required init(interactor: Interactable, controller: Controllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

class UserLoginPageComponentBuilder: MolueComponentBuilder, UserLoginPageComponentBuildable {
    func build() -> UIViewController {
        let controller = UserLoginPageViewController.initializeFromStoryboard()
        let interactor = UserLoginPagePageInteractor(presenter: controller)
        UserLoginPageViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
    
    func build(listener: UserLoginPageInteractListener) -> UIViewController {
        let controller = UserLoginPageViewController.initializeFromStoryboard()
        let interactor = UserLoginPagePageInteractor(presenter: controller)
        UserLoginPageViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
