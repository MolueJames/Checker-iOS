//
//  RiskFollowBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskFollowRouterInteractable: RiskDetailInteractListener {
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

class RiskFollowComponentBuilder: MolueComponentBuilder, RiskFollowComponentBuildable {
    func build(listener: RiskFollowInteractListener) -> UIViewController {
        let controller = RiskFollowViewController.initializeFromStoryboard()
        let interactor = RiskFollowPageInteractor(presenter: controller)
        RiskFollowViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
