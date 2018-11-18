//
//  AppChatPageBuilderRouter.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol AppChatPageRouterInteractable: class {
    var viewRouter: AppChatPageViewableRouting? { get set }
    var listener: AppChatPageInteractListener? { get set }
}

protocol AppChatPageViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class AppChatPageViewableRouter: MolueViewableRouting {
    
    weak var interactor: AppChatPageRouterInteractable?
    
    weak var controller: AppChatPageViewControllable?
    
    @discardableResult
    required init(interactor: AppChatPageRouterInteractable, controller: AppChatPageViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension AppChatPageViewableRouter: AppChatPageViewableRouting {
    
}

class AppChatPageComponentBuilder: MolueComponentBuilder, AppChatPageComponentBuildable {
    func build(listener: AppChatPageInteractListener) -> UIViewController {
        let controller = AppChatPageViewController.initializeFromStoryboard()
        let interactor = AppChatPagePageInteractor(presenter: controller)
        AppChatPageViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = AppChatPageViewController.initializeFromStoryboard()
        let interactor = AppChatPagePageInteractor(presenter: controller)
        AppChatPageViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
