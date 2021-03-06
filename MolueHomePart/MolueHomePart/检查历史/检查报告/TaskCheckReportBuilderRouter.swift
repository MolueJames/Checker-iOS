//
//  TaskCheckReportBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol TaskCheckReportRouterInteractable: RiskDetailInteractListener {
    var viewRouter: TaskCheckReportViewableRouting? { get set }
    var listener: TaskCheckReportInteractListener? { get set }
}

protocol TaskCheckReportViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class TaskCheckReportViewableRouter: MolueViewableRouting {
    
    weak var interactor: TaskCheckReportRouterInteractable?
    
    weak var controller: TaskCheckReportViewControllable?
    
    @discardableResult
    required init(interactor: TaskCheckReportRouterInteractable, controller: TaskCheckReportViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension TaskCheckReportViewableRouter: TaskCheckReportViewableRouting {
    func pushToHiddenPerilController() {
        do {
            let listener = try self.interactor.unwrap()
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.RiskDetail)
            let builder: RiskDetailComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol TaskCheckReportInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var currentTask: MLDailyCheckTask? {get}
}

protocol TaskCheckReportComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: TaskCheckReportInteractListener) -> UIViewController
}

public class TaskCheckReportComponentBuilder: MolueComponentBuilder, TaskCheckReportComponentBuildable {
    func build(listener: TaskCheckReportInteractListener) -> UIViewController {
        let controller = TaskCheckReportViewController.initializeFromStoryboard()
        let interactor = TaskCheckReportPageInteractor(presenter: controller)
        TaskCheckReportViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
