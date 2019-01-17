//
//  AdvertiseContentBuilderRouter.swift
//  MolueHomePart
//
//  Created by MolueJames on 2019/1/15.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol AdvertiseContentRouterInteractable: class {
    var viewRouter: AdvertiseContentViewableRouting? { get set }
    var listener: AdvertiseContentInteractListener? { get set }
}

protocol AdvertiseContentViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class AdvertiseContentViewableRouter: MolueViewableRouting {
    
    weak var interactor: AdvertiseContentRouterInteractable?
    
    weak var controller: AdvertiseContentViewControllable?
    
    @discardableResult
    required init(interactor: AdvertiseContentRouterInteractable, controller: AdvertiseContentViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension AdvertiseContentViewableRouter: AdvertiseContentViewableRouting {
    
}

protocol AdvertiseContentInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var advertisement: MLAdvertiseContent? { get }
}

protocol AdvertiseContentComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: AdvertiseContentInteractListener) -> UIViewController
}

class AdvertiseContentComponentBuilder: MolueComponentBuilder, AdvertiseContentComponentBuildable {
    func build(listener: AdvertiseContentInteractListener) -> UIViewController {
        let controller = AdvertiseContentViewController.initializeFromStoryboard()
        let interactor = AdvertiseContentPageInteractor(presenter: controller)
        AdvertiseContentViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
