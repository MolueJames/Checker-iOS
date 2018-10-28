//
//  ForgetPasswordBuilderRouter.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol ForgetPasswordRouterInteractable: class {
    var viewRouter: ForgetPasswordViewableRouting? { get set }
    var listener: ForgetPasswordInteractListener? { get set }
}

protocol ForgetPasswordViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class ForgetPasswordViewableRouter: MolueViewableRouting {
 
    weak var interactor: ForgetPasswordRouterInteractable?
    
    weak var controller: ForgetPasswordViewControllable?
    
    @discardableResult
    required init(interactor: ForgetPasswordRouterInteractable, controller: ForgetPasswordViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension ForgetPasswordViewableRouter: ForgetPasswordViewableRouting {
    func popBackFromForgetPassword() {
        do {
            try self.controller.unwrap().doPopBackFromCurrent()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol ForgetPasswordInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol ForgetPasswordComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: ForgetPasswordInteractListener) -> UIViewController
}

class ForgetPasswordComponentBuilder: MolueComponentBuilder, ForgetPasswordComponentBuildable {
    func build(listener: ForgetPasswordInteractListener) -> UIViewController {
        let controller = ForgetPasswordViewController.initializeFromStoryboard()
        let interactor = ForgetPasswordPageInteractor(presenter: controller)
        ForgetPasswordViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
