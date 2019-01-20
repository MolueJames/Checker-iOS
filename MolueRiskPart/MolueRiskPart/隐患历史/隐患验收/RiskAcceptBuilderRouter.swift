//
//  RiskAcceptBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskAcceptRouterInteractable: class {
    var viewRouter: RiskAcceptViewableRouting? { get set }
    var listener: RiskAcceptInteractListener? { get set }
}

protocol RiskAcceptViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskAcceptViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskAcceptRouterInteractable?
    
    weak var controller: RiskAcceptViewControllable?
    
    @discardableResult
    required init(interactor: RiskAcceptRouterInteractable, controller: RiskAcceptViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskAcceptViewableRouter: RiskAcceptViewableRouting {
    
}

protocol RiskAcceptInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskAcceptComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskAcceptInteractListener) -> UIViewController
}

class RiskAcceptComponentBuilder: MolueComponentBuilder, RiskAcceptComponentBuildable {
    func build(listener: RiskAcceptInteractListener) -> UIViewController {
        let controller = RiskAcceptViewController()
        let interactor = RiskAcceptPageInteractor(presenter: controller)
        RiskAcceptViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
