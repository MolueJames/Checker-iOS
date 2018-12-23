
//
//  PolicyDetailBuilderRouter.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork

protocol PolicyDetailRouterInteractable: class {
    var viewRouter: PolicyDetailViewableRouting? { get set }
    var listener: PolicyDetailInteractListener? { get set }
}

protocol PolicyDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
    
}

final class PolicyDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: PolicyDetailRouterInteractable?
    
    weak var controller: PolicyDetailViewControllable?
    
    @discardableResult
    required init(interactor: PolicyDetailRouterInteractable, controller: PolicyDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension PolicyDetailViewableRouter: PolicyDetailViewableRouting {
    
}

protocol PolicyDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var selectedPolicyNotice: MLPolicyNoticeModel? {get}
    
    func updatePolicyNotice(with notice: MLPolicyNoticeModel)
}

protocol PolicyDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: PolicyDetailInteractListener) -> UIViewController
}

class PolicyDetailComponentBuilder: MolueComponentBuilder, PolicyDetailComponentBuildable {
    func build(listener: PolicyDetailInteractListener) -> UIViewController {
        let controller = PolicyDetailViewController.initializeFromStoryboard()
        let interactor = PolicyDetailPageInteractor(presenter: controller)
        PolicyDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
