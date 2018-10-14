//
//  RegisterAccountBuilderRouter.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/13.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol RegisterAccountRouterInteractable: class {
    var viewRouter: RegisterAccountViewableRouting? { get set }
    var listener: RegisterAccountInteractListener? { get set }
}

protocol RegisterAccountViewControllable: class {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RegisterAccountViewableRouter: MolueViewableRouting, RegisterAccountViewableRouting {
    
    typealias Interactable = RegisterAccountRouterInteractable
    weak var interactor: Interactable?
    
    typealias Controllable = RegisterAccountViewControllable
    weak var controller: Controllable?
    
    @discardableResult
    required init(interactor: Interactable, controller: Controllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}

protocol RegisterAccountInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RegisterAccountComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RegisterAccountInteractListener) -> UIViewController
}

class RegisterAccountComponentBuilder: MolueComponentBuilder, RegisterAccountComponentBuildable {
    func build(listener: RegisterAccountInteractListener) -> UIViewController {
        let controller = RegisterAccountViewController.initializeFromStoryboard()
        let interactor = RegisterAccountPageInteractor(presenter: controller)
        RegisterAccountViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
