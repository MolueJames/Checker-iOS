//
//  RiskFollowBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskFollowRouterInteractable: class {
    var viewRouter: RiskFollowViewableRouting? { get set }
    var listener: RiskFollowInteractListener? { get set }
}

protocol RiskFollowViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskFollowViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskFollowRouterInteractable?
    
    weak var controller: RiskFollowViewControllable?
    
    @discardableResult
    required init(interactor: RiskFollowRouterInteractable, controller: RiskFollowViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskFollowViewableRouter: RiskFollowViewableRouting {
    
}

protocol RiskFollowInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskFollowComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskFollowInteractListener) -> UIViewController
}

class RiskFollowComponentBuilder: MolueComponentBuilder, RiskFollowComponentBuildable {
    func build(listener: RiskFollowInteractListener) -> UIViewController {
        let controller = RiskFollowViewController()
        let interactor = RiskFollowPageInteractor(presenter: controller)
        RiskFollowViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
