//
//  RiskPointListBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskPointListRouterInteractable: class {
    var viewRouter: RiskPointListViewableRouting? { get set }
    var listener: RiskPointListInteractListener? { get set }
}

protocol RiskPointListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskPointListViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskPointListRouterInteractable?
    
    weak var controller: RiskPointListViewControllable?
    
    @discardableResult
    required init(interactor: RiskPointListRouterInteractable, controller: RiskPointListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskPointListViewableRouter: RiskPointListViewableRouting {
    
}

protocol RiskPointListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var riskUnitDetail: MLRiskUnitDetail? {get}
}

protocol RiskPointListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskPointListInteractListener) -> UIViewController
}

class RiskPointListComponentBuilder: MolueComponentBuilder, RiskPointListComponentBuildable {
    func build(listener: RiskPointListInteractListener) -> UIViewController {
        let controller = RiskPointListViewController.initializeFromStoryboard()
        let interactor = RiskPointListPageInteractor(presenter: controller)
        RiskPointListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
