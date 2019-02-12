//
//  RiskUnitListBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskUnitListRouterInteractable: RiskPointListInteractListener {
    var viewRouter: RiskUnitListViewableRouting? { get set }
    var listener: RiskUnitListInteractListener? { get set }
}

protocol RiskUnitListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskUnitListViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskUnitListRouterInteractable?
    
    weak var controller: RiskUnitListViewControllable?
    
    @discardableResult
    required init(interactor: RiskUnitListRouterInteractable, controller: RiskUnitListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskUnitListViewableRouter: RiskUnitListViewableRouting {
    func pushToRiskPointListController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskPointListComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
}

protocol RiskUnitListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskUnitListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskUnitListInteractListener) -> UIViewController
}

class RiskUnitListComponentBuilder: MolueComponentBuilder, RiskUnitListComponentBuildable {
    func build(listener: RiskUnitListInteractListener) -> UIViewController {
        let controller = RiskUnitListViewController.initializeFromStoryboard()
        let interactor = RiskUnitListPageInteractor(presenter: controller)
        RiskUnitListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
