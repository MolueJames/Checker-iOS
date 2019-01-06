//
//  HiddenPerilListBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol HiddenPerilListRouterInteractable: class {
    var viewRouter: HiddenPerilListViewableRouting? { get set }
    var listener: HiddenPerilListInteractListener? { get set }
}

protocol HiddenPerilListViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class HiddenPerilListViewableRouter: MolueViewableRouting {
    
    weak var interactor: HiddenPerilListRouterInteractable?
    
    weak var controller: HiddenPerilListViewControllable?
    
    @discardableResult
    required init(interactor: HiddenPerilListRouterInteractable, controller: HiddenPerilListViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension HiddenPerilListViewableRouter: HiddenPerilListViewableRouting {
    
}

protocol HiddenPerilListInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol HiddenPerilListComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: HiddenPerilListInteractListener) -> UIViewController
}

class HiddenPerilListComponentBuilder: MolueComponentBuilder, HiddenPerilListComponentBuildable {
    func build(listener: HiddenPerilListInteractListener) -> UIViewController {
        let controller = HiddenPerilListViewController.initializeFromStoryboard()
        let interactor = HiddenPerilListPageInteractor(presenter: controller)
        HiddenPerilListViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
