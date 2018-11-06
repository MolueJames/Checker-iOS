//
//  RiskCheckTaskBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskCheckTaskRouterInteractable: class {
    var viewRouter: RiskCheckTaskViewableRouting? { get set }
    var listener: RiskCheckTaskInteractListener? { get set }
}

protocol RiskCheckTaskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskCheckTaskViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskCheckTaskRouterInteractable?
    
    weak var controller: RiskCheckTaskViewControllable?
    
    @discardableResult
    required init(interactor: RiskCheckTaskRouterInteractable, controller: RiskCheckTaskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskCheckTaskViewableRouter: RiskCheckTaskViewableRouting {
    
}

protocol RiskCheckTaskInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskCheckTaskComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskCheckTaskInteractListener) -> UIViewController
}

class RiskCheckTaskComponentBuilder: MolueComponentBuilder, RiskCheckTaskComponentBuildable {
    func build(listener: RiskCheckTaskInteractListener) -> UIViewController {
        let controller = RiskCheckTaskViewController.initializeFromStoryboard()
        let interactor = RiskCheckTaskPageInteractor(presenter: controller)
        RiskCheckTaskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
