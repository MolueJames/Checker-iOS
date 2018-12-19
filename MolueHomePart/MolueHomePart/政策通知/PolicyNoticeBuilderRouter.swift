//
//  PolicyNoticeBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol PolicyNoticeRouterInteractable: PolicyDetailInteractListener {
    var viewRouter: PolicyNoticeViewableRouting? { get set }
    var listener: PolicyNoticeInteractListener? { get set }
}

protocol PolicyNoticeViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class PolicyNoticeViewableRouter: MolueViewableRouting {
    
    weak var interactor: PolicyNoticeRouterInteractable?
    
    weak var controller: PolicyNoticeViewControllable?
    
    @discardableResult
    required init(interactor: PolicyNoticeRouterInteractable, controller: PolicyNoticeViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension PolicyNoticeViewableRouter: PolicyNoticeViewableRouting {
    func pushToPolicyDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = PolicyDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol PolicyNoticeInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol PolicyNoticeComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: PolicyNoticeInteractListener) -> UIViewController
    
    func build() -> UIViewController
}

class PolicyNoticeComponentBuilder: MolueComponentBuilder, PolicyNoticeComponentBuildable {
    func build(listener: PolicyNoticeInteractListener) -> UIViewController {
        let controller = PolicyNoticeViewController()
        let interactor = PolicyNoticePageInteractor(presenter: controller)
        PolicyNoticeViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = PolicyNoticeViewController.initializeFromStoryboard()
        let interactor = PolicyNoticePageInteractor(presenter: controller)
        PolicyNoticeViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
