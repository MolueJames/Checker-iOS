//
//  RiskClosedBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskClosedRouterInteractable: class {
    var viewRouter: RiskClosedViewableRouting? { get set }
    var listener: RiskClosedInteractListener? { get set }
}

protocol RiskClosedViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskClosedViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskClosedRouterInteractable?
    
    weak var controller: RiskClosedViewControllable?
    
    @discardableResult
    required init(interactor: RiskClosedRouterInteractable, controller: RiskClosedViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskClosedViewableRouter: RiskClosedViewableRouting {
    
}

protocol RiskClosedInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskClosedComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskClosedInteractListener) -> UIViewController
}

class RiskClosedComponentBuilder: MolueComponentBuilder, RiskClosedComponentBuildable {
    func build(listener: RiskClosedInteractListener) -> UIViewController {
        let controller = RiskClosedViewController()
        let interactor = RiskClosedPageInteractor(presenter: controller)
        RiskClosedViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
