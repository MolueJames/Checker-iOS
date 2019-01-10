//
//  HiddenPerilLevelBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol HiddenPerilLevelRouterInteractable: class {
    var viewRouter: HiddenPerilLevelViewableRouting? { get set }
    var listener: HiddenPerilLevelInteractListener? { get set }
}

protocol HiddenPerilLevelViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class HiddenPerilLevelViewableRouter: MolueViewableRouting {
    
    weak var interactor: HiddenPerilLevelRouterInteractable?
    
    weak var controller: HiddenPerilLevelViewControllable?
    
    @discardableResult
    required init(interactor: HiddenPerilLevelRouterInteractable, controller: HiddenPerilLevelViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension HiddenPerilLevelViewableRouter: HiddenPerilLevelViewableRouting {
    
}

protocol HiddenPerilLevelInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol HiddenPerilLevelComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: HiddenPerilLevelInteractListener) -> UIViewController
}

class HiddenPerilLevelComponentBuilder: MolueComponentBuilder, HiddenPerilLevelComponentBuildable {
    func build(listener: HiddenPerilLevelInteractListener) -> UIViewController {
        let controller = HiddenPerilLevelViewController.initializeFromStoryboard()
        let interactor = HiddenPerilLevelPageInteractor(presenter: controller)
        HiddenPerilLevelViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
