//
//  FailureTaskListBuilderRouter.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol FailureTaskListRouterInteractable: EditRiskInfoInteractListener {
    var viewRouter: FailureTaskListViewableRouting? { get set }
    var listener: FailureTaskListInteractListener? { get set }
}

protocol FailureTaskListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
    
}

final class FailureTaskListViewableRouter: MolueViewableRouting {
    
    weak var interactor: FailureTaskListRouterInteractable?
    
    weak var controller: FailureTaskListViewControllable?
    
    @discardableResult
    required init(interactor: FailureTaskListRouterInteractable, controller: FailureTaskListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension FailureTaskListViewableRouter: FailureTaskListViewableRouting {
    func pushToEditRiskInfoController() {
        do {
            let listener = try self.interactor.unwrap()
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.EditRisk)
            let builder: EditRiskInfoComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol FailureTaskListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var selectedCheckTask: MLDailyCheckTask? {get}
}

protocol FailureTaskListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: FailureTaskListInteractListener) -> UIViewController
}

class FailureTaskListComponentBuilder: MolueComponentBuilder, FailureTaskListComponentBuildable {
    func build(listener: FailureTaskListInteractListener) -> UIViewController {
        let controller = FailureTaskListViewController.initializeFromStoryboard()
        let interactor = FailureTaskListPageInteractor(presenter: controller)
        FailureTaskListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
