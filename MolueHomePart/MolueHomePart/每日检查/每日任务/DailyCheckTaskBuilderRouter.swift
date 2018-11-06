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
    func pushToCheckTaskDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = CheckTaskDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            MoluePageNavigator().pushViewController(controller)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol DailyCheckTaskInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol DailyCheckTaskComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: DailyCheckTaskInteractListener) -> UIViewController
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
