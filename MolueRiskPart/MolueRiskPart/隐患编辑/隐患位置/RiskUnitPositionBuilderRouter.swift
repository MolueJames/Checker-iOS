//
//  RiskUnitPositionBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskUnitPositionRouterInteractable: class {
    var viewRouter: RiskUnitPositionViewableRouting? { get set }
    var listener: RiskUnitPositionInteractListener? { get set }
}

protocol RiskUnitPositionViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskUnitPositionViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskUnitPositionRouterInteractable?
    
    weak var controller: RiskUnitPositionViewControllable?
    
    @discardableResult
    required init(interactor: RiskUnitPositionRouterInteractable, controller: RiskUnitPositionViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskUnitPositionViewableRouter: RiskUnitPositionViewableRouting {
    func popBackToPreviousController() {
        do {
            let navigator = try self.controller.unwrap()
            navigator.doPopBackFromCurrent()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol RiskUnitPositionInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    func updateRiskPointPosition(with value: MLRiskPointDetail)
}

protocol RiskUnitPositionComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskUnitPositionInteractListener) -> UIViewController
}

class RiskUnitPositionComponentBuilder: MolueComponentBuilder, RiskUnitPositionComponentBuildable {
    func build(listener: RiskUnitPositionInteractListener) -> UIViewController {
        let controller = RiskUnitPositionViewController.initializeFromStoryboard()
        let interactor = RiskUnitPositionPageInteractor(presenter: controller)
        RiskUnitPositionViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
