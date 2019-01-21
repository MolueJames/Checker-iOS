//
//  HiddenPerilListBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol HiddenPerilListRouterInteractable: RiskDetailInteractListener, RiskArrangeInteractListener, RiskClosedInteractListener, RiskRectifyInteractListener, RiskScheduleInteractListener, RiskPlanedInteractListener {
    var viewRouter: HiddenPerilListViewableRouting? { get set }
    var listener: HiddenPerilListInteractListener? { get set }
}

protocol HiddenPerilListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class HiddenPerilListViewableRouter: MolueViewableRouting {
    
    weak var interactor: HiddenPerilListRouterInteractable?
    
    weak var controller: HiddenPerilListViewControllable?
    
    @discardableResult
    required init(interactor: HiddenPerilListRouterInteractable, controller: HiddenPerilListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension HiddenPerilListViewableRouter: HiddenPerilListViewableRouting {
    func pushToRiskPlanedController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskPlanedComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func pushToRiskScheduleController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskScheduleComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func pushToRiskDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func pushToRiskClosedControlelr() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskClosedComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func pushToRiskArrangeController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskArrangeComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func pushToRiskRectifyController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskRectifyComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
}

class HiddenPerilListComponentBuilder: MolueComponentBuilder, HiddenPerilListComponentBuildable {
    func build(listener: HiddenPerilListInteractListener, status: PotentialRiskStatus) -> UIViewController {
        let controller = HiddenPerilListViewController.initializeFromStoryboard()
        let interactor = HiddenPerilListPageInteractor(presenter: controller)
        HiddenPerilListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        interactor.status = status
        return controller
    }
}
