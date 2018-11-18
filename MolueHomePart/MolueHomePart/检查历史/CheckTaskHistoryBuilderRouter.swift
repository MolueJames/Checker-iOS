//
//  CheckTaskHistoryBuilderRouter.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol CheckTaskHistoryRouterInteractable: class {
    var viewRouter: CheckTaskHistoryViewableRouting? { get set }
    var listener: CheckTaskHistoryInteractListener? { get set }
}

protocol CheckTaskHistoryViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class CheckTaskHistoryViewableRouter: MolueViewableRouting {
    
    weak var interactor: CheckTaskHistoryRouterInteractable?
    
    weak var controller: CheckTaskHistoryViewControllable?
    
    @discardableResult
    required init(interactor: CheckTaskHistoryRouterInteractable, controller: CheckTaskHistoryViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension CheckTaskHistoryViewableRouter: CheckTaskHistoryViewableRouting {
    
}

protocol CheckTaskHistoryInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol CheckTaskHistoryComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: CheckTaskHistoryInteractListener) -> UIViewController
}

class CheckTaskHistoryComponentBuilder: MolueComponentBuilder, CheckTaskHistoryComponentBuildable {
    func build(listener: CheckTaskHistoryInteractListener) -> UIViewController {
        let controller = CheckTaskHistoryViewController.initializeFromStoryboard()
        let interactor = CheckTaskHistoryPageInteractor(presenter: controller)
        CheckTaskHistoryViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
