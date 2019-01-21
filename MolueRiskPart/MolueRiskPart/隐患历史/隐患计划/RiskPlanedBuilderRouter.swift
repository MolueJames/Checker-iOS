//
//  RiskPlanedBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskPlanedRouterInteractable: RiskDetailInteractListener {
    var viewRouter: RiskPlanedViewableRouting? { get set }
    var listener: RiskPlanedInteractListener? { get set }
}

protocol RiskPlanedViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskPlanedViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskPlanedRouterInteractable?
    
    weak var controller: RiskPlanedViewControllable?
    
    @discardableResult
    required init(interactor: RiskPlanedRouterInteractable, controller: RiskPlanedViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskPlanedViewableRouter: RiskPlanedViewableRouting {
    func pushToRiskDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
}

protocol RiskPlanedInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var hiddenPeril: MLHiddenPerilItem? { get }
}

protocol RiskPlanedComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskPlanedInteractListener) -> UIViewController
}

class RiskPlanedComponentBuilder: MolueComponentBuilder, RiskPlanedComponentBuildable {
    func build(listener: RiskPlanedInteractListener) -> UIViewController {
        let controller = RiskPlanedViewController()
        let interactor = RiskPlanedPageInteractor(presenter: controller)
        RiskPlanedViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
