//
//  AboutUsInfoBuilderRouter.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol AboutUsInfoRouterInteractable: class {
    var viewRouter: AboutUsInfoViewableRouting? { get set }
    var listener: AboutUsInfoInteractListener? { get set }
}

protocol AboutUsInfoViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class AboutUsInfoViewableRouter: MolueViewableRouting {
    
    weak var interactor: AboutUsInfoRouterInteractable?
    
    weak var controller: AboutUsInfoViewControllable?
    
    @discardableResult
    required init(interactor: AboutUsInfoRouterInteractable, controller: AboutUsInfoViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension AboutUsInfoViewableRouter: AboutUsInfoViewableRouting {
    
}

protocol AboutUsInfoInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol AboutUsInfoComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: AboutUsInfoInteractListener) -> UIViewController
}

class AboutUsInfoComponentBuilder: MolueComponentBuilder, AboutUsInfoComponentBuildable {
    func build(listener: AboutUsInfoInteractListener) -> UIViewController {
        let controller = AboutUsInfoViewController()
        let interactor = AboutUsInfoPageInteractor(presenter: controller)
        AboutUsInfoViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
