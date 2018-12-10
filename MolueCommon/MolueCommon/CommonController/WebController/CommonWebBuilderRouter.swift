//
//  CommonWebBuilderRouter.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/12/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol CommonWebRouterInteractable: class {
    var viewRouter: CommonWebViewableRouting? { get set }
    var listener: CommonWebInteractListener? { get set }
}

protocol CommonWebViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class CommonWebViewableRouter: MolueViewableRouting {
    
    weak var interactor: CommonWebRouterInteractable?
    
    weak var controller: CommonWebViewControllable?
    
    @discardableResult
    required init(interactor: CommonWebRouterInteractable, controller: CommonWebViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension CommonWebViewableRouter: CommonWebViewableRouting {
    
}

class CommonWebComponentBuilder: MolueComponentBuilder, CommonWebComponentBuildable {
    func build(listener: CommonWebInteractListener) -> UIViewController {
        let controller = CommonWebViewController()
        let interactor = CommonWebPageInteractor(presenter: controller)
        CommonWebViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
