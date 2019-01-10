//
//  RiskClassificationsBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskClassificationsRouterInteractable: class {
    var viewRouter: RiskClassificationsViewableRouting? { get set }
    var listener: RiskClassificationsInteractListener? { get set }
}

protocol RiskClassificationsViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskClassificationsViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskClassificationsRouterInteractable?
    
    weak var controller: RiskClassificationsViewControllable?
    
    @discardableResult
    required init(interactor: RiskClassificationsRouterInteractable, controller: RiskClassificationsViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskClassificationsViewableRouter: RiskClassificationsViewableRouting {
    
}

protocol RiskClassificationsInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    func updateClassification(with value: MLRiskClassification)
}

protocol RiskClassificationsComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskClassificationsInteractListener) -> UIViewController
}

class RiskClassificationsComponentBuilder: MolueComponentBuilder, RiskClassificationsComponentBuildable {
    func build(listener: RiskClassificationsInteractListener) -> UIViewController {
        let controller = RiskClassificationsViewController.initializeFromStoryboard()
        let interactor = RiskClassificationsPageInteractor(presenter: controller)
        RiskClassificationsViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
