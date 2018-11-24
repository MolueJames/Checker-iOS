//
//  PotentialRiskBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol PotentialRiskRouterInteractable: RiskDetailInteractListener {
    var viewRouter: PotentialRiskViewableRouting? { get set }
    var listener: PotentialRiskInteractListener? { get set }
}

protocol PotentialRiskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class PotentialRiskViewableRouter: MolueViewableRouting {
    
    weak var interactor: PotentialRiskRouterInteractable?
    
    weak var controller: PotentialRiskViewControllable?
    
    @discardableResult
    required init(interactor: PotentialRiskRouterInteractable, controller: PotentialRiskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension PotentialRiskViewableRouter: PotentialRiskViewableRouting {
    func pushToRiskDetailController() {
        do {
            let builder: RiskDetailComponentBuildable = RiskDetailComponentBuilder()
            let controller = try builder.build(listener: self.interactor.unwrap())
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

class PotentialRiskComponentBuilder: MolueComponentBuilder, PotentialRiskComponentBuildable {
    func build(listener: PotentialRiskInteractListener) -> UIViewController {
        let controller = PotentialRiskViewController.initializeFromStoryboard()
        let interactor = PotentialRiskPageInteractor(presenter: controller)
        PotentialRiskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
