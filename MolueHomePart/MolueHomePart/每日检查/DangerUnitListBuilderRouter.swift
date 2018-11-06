//
//  DangerUnitListBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol DangerUnitListRouterInteractable: DailyCheckTaskInteractListener {
    var viewRouter: DangerUnitListViewableRouting? { get set }
    var listener: DangerUnitListInteractListener? { get set }
}

protocol DangerUnitListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class DangerUnitListViewableRouter: MolueViewableRouting {
    
    weak var interactor: DangerUnitListRouterInteractable?
    
    weak var controller: DangerUnitListViewControllable?
    
    @discardableResult
    required init(interactor: DangerUnitListRouterInteractable, controller: DangerUnitListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension DangerUnitListViewableRouter: DangerUnitListViewableRouting {
    func pushToDailyCheckTaskController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = DailyCheckTaskComponentBuilder()
            let controller = builder.build(listener: listener)
            MoluePageNavigator().pushViewController(controller)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol DangerUnitListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol DangerUnitListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: DangerUnitListInteractListener) -> UIViewController
}

class DangerUnitListComponentBuilder: MolueComponentBuilder, DangerUnitListComponentBuildable {
    func build(listener: DangerUnitListInteractListener) -> UIViewController {
        let controller = DangerUnitListViewController.initializeFromStoryboard()
        let interactor = DangerUnitListPageInteractor(presenter: controller)
        DangerUnitListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
