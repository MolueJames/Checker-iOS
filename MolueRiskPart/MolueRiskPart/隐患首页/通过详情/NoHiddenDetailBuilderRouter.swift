//
//  NoHiddenDetailBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol NoHiddenDetailRouterInteractable: class {
    var viewRouter: NoHiddenDetailViewableRouting? { get set }
    var listener: NoHiddenDetailInteractListener? { get set }
}

protocol NoHiddenDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class NoHiddenDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: NoHiddenDetailRouterInteractable?
    
    weak var controller: NoHiddenDetailViewControllable?
    
    @discardableResult
    required init(interactor: NoHiddenDetailRouterInteractable, controller: NoHiddenDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension NoHiddenDetailViewableRouter: NoHiddenDetailViewableRouting {
    
}

protocol NoHiddenDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol NoHiddenDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: NoHiddenDetailInteractListener) -> UIViewController
}

class NoHiddenDetailComponentBuilder: MolueComponentBuilder, NoHiddenDetailComponentBuildable {
    func build(listener: NoHiddenDetailInteractListener) -> UIViewController {
        let controller = NoHiddenDetailViewController()
        let interactor = NoHiddenDetailPageInteractor(presenter: controller)
        NoHiddenDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
