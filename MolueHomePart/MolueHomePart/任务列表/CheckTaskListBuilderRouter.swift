//
//  CheckTaskListBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol CheckTaskListRouterInteractable: DailyCheckTaskInteractListener {
    var viewRouter: CheckTaskListViewableRouting? { get set }
    var listener: CheckTaskListInteractListener? { get set }
}

protocol CheckTaskListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class CheckTaskListViewableRouter: MolueViewableRouting {
    
    weak var interactor: CheckTaskListRouterInteractable?
    
    weak var controller: CheckTaskListViewControllable?
    
    @discardableResult
    required init(interactor: CheckTaskListRouterInteractable, controller: CheckTaskListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension CheckTaskListViewableRouter: CheckTaskListViewableRouting {
    func pushToDailyCheckTaskController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = DailyCheckTaskComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol CheckTaskListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol CheckTaskListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: CheckTaskListInteractListener) -> UIViewController
}

class CheckTaskListComponentBuilder: MolueComponentBuilder, CheckTaskListComponentBuildable {
    func build(listener: CheckTaskListInteractListener) -> UIViewController {
        let controller = CheckTaskListViewController.initializeFromStoryboard()
        let interactor = CheckTaskListPageInteractor(presenter: controller)
        CheckTaskListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
