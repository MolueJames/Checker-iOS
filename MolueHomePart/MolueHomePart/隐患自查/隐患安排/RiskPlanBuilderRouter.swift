//
//  RiskPlanBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskPlanRouterInteractable: class {
    var viewRouter: RiskPlanViewableRouting? { get set }
    var listener: RiskPlanInteractListener? { get set }
}

protocol RiskPlanViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskPlanViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskPlanRouterInteractable?
    
    weak var controller: RiskPlanViewControllable?
    
    @discardableResult
    required init(interactor: RiskPlanRouterInteractable, controller: RiskPlanViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskPlanViewableRouter: RiskPlanViewableRouting {
    
}

protocol RiskPlanInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskPlanComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskPlanInteractListener) -> UIViewController
}

class RiskPlanComponentBuilder: MolueComponentBuilder, RiskPlanComponentBuildable {
    func build(listener: RiskPlanInteractListener) -> UIViewController {
        let controller = RiskPlanViewController.initializeFromStoryboard()
        let interactor = RiskPlanPageInteractor(presenter: controller)
        RiskPlanViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
