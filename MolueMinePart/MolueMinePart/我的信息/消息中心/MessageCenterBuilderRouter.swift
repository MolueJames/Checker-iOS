//
//  MessageCenterBuilderRouter.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol MessageCenterRouterInteractable: class {
    var viewRouter: MessageCenterViewableRouting? { get set }
    var listener: MessageCenterInteractListener? { get set }
}

protocol MessageCenterViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class MessageCenterViewableRouter: MolueViewableRouting {
    
    weak var interactor: MessageCenterRouterInteractable?
    
    weak var controller: MessageCenterViewControllable?
    
    @discardableResult
    required init(interactor: MessageCenterRouterInteractable, controller: MessageCenterViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension MessageCenterViewableRouter: MessageCenterViewableRouting {
    
}

protocol MessageCenterInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol MessageCenterComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: MessageCenterInteractListener) -> UIViewController
}

class MessageCenterComponentBuilder: MolueComponentBuilder, MessageCenterComponentBuildable {
    func build(listener: MessageCenterInteractListener) -> UIViewController {
        let controller = MessageCenterViewController()
        let interactor = MessageCenterPageInteractor(presenter: controller)
        MessageCenterViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
