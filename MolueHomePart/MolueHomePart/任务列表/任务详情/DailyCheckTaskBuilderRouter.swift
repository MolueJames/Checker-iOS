//
//  DailyCheckTaskBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol DailyCheckTaskRouterInteractable: CheckTaskDetailInteractListener {
    var viewRouter: DailyCheckTaskViewableRouting? { get set }
    var listener: DailyCheckTaskInteractListener? { get set }
}

protocol DailyCheckTaskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class DailyCheckTaskViewableRouter: MolueViewableRouting {
    
    weak var interactor: DailyCheckTaskRouterInteractable?
    
    weak var controller: DailyCheckTaskViewControllable?
    
    @discardableResult
    required init(interactor: DailyCheckTaskRouterInteractable, controller: DailyCheckTaskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension DailyCheckTaskViewableRouter: DailyCheckTaskViewableRouting {
    func pushToCheckTaskReportController() {
        
    }
    
    func pushToCheckTaskDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = CheckTaskDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

class DailyCheckTaskComponentBuilder: MolueComponentBuilder, DailyCheckTaskComponentBuildable {
    func build(listener: DailyCheckTaskInteractListener) -> UIViewController {
        let controller = DailyCheckTaskViewController.initializeFromStoryboard()
        let interactor = DailyCheckTaskPageInteractor(presenter: controller)
        DailyCheckTaskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
