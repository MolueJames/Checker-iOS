//
//  RiskScheduleBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskScheduleRouterInteractable: RiskDetailInteractListener {
    var viewRouter: RiskScheduleViewableRouting? { get set }
    var listener: RiskScheduleInteractListener? { get set }
}

protocol RiskScheduleViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskScheduleViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskScheduleRouterInteractable?
    
    weak var controller: RiskScheduleViewControllable?
    
    @discardableResult
    required init(interactor: RiskScheduleRouterInteractable, controller: RiskScheduleViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskScheduleViewableRouter: RiskScheduleViewableRouting {
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

protocol RiskScheduleInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var hiddenPeril: MLHiddenPerilItem? { get }
}

protocol RiskScheduleComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskScheduleInteractListener) -> UIViewController
}

class RiskScheduleComponentBuilder: MolueComponentBuilder, RiskScheduleComponentBuildable {
    func build(listener: RiskScheduleInteractListener) -> UIViewController {
        let controller = RiskScheduleViewController()
        let interactor = RiskSchedulePageInteractor(presenter: controller)
        RiskScheduleViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
