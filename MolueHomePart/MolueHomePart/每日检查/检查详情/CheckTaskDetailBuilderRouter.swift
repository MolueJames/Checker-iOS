//
//  CheckTaskDetailBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol CheckTaskDetailRouterInteractable: class {
    var viewRouter: CheckTaskDetailViewableRouting? { get set }
    var listener: CheckTaskDetailInteractListener? { get set }
}

protocol CheckTaskDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class CheckTaskDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: CheckTaskDetailRouterInteractable?
    
    weak var controller: CheckTaskDetailViewControllable?
    
    @discardableResult
    required init(interactor: CheckTaskDetailRouterInteractable, controller: CheckTaskDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension CheckTaskDetailViewableRouter: CheckTaskDetailViewableRouting {
    
}

protocol CheckTaskDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol CheckTaskDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: CheckTaskDetailInteractListener) -> UIViewController
}

class CheckTaskDetailComponentBuilder: MolueComponentBuilder, CheckTaskDetailComponentBuildable {
    func build(listener: CheckTaskDetailInteractListener) -> UIViewController {
        let controller = CheckTaskDetailViewController()
        let interactor = CheckTaskDetailPageInteractor(presenter: controller)
        CheckTaskDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
