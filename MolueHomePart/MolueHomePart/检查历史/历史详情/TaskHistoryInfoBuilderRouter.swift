//
//  TaskHistoryInfoBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol TaskHistoryInfoRouterInteractable: RiskDetailInteractListener, NoHiddenDetailInteractListener {
    var viewRouter: TaskHistoryInfoViewableRouting? { get set }
    var listener: TaskHistoryInfoInteractListener? { get set }
}

protocol TaskHistoryInfoViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class TaskHistoryInfoViewableRouter: MolueViewableRouting {
    
    weak var interactor: TaskHistoryInfoRouterInteractable?
    
    weak var controller: TaskHistoryInfoViewControllable?
    
    @discardableResult
    required init(interactor: TaskHistoryInfoRouterInteractable, controller: TaskHistoryInfoViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension TaskHistoryInfoViewableRouter: TaskHistoryInfoViewableRouting {
    func pushToRiskDetailController() {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.RiskDetail)
            let builder: RiskDetailComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: self.interactor.unwrap())
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToNoHiddenInfoController() {
        do {
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.NoHiddenItem)
            let builder: NoHiddenDetailComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: self.interactor.unwrap())
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol TaskHistoryInfoInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
//    var taskItem: DangerUnitRiskModel? {get}
}

protocol TaskHistoryInfoComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: TaskHistoryInfoInteractListener) -> UIViewController
}

class TaskHistoryInfoComponentBuilder: MolueComponentBuilder, TaskHistoryInfoComponentBuildable {
    func build(listener: TaskHistoryInfoInteractListener) -> UIViewController {
        let controller = TaskHistoryInfoViewController.initializeFromStoryboard()
        let interactor = TaskHistoryInfoPageInteractor(presenter: controller)
        TaskHistoryInfoViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
