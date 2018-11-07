//
//  UserInfoCenterBuilderRouter.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol UserInfoCenterRouterInteractable: MessageCenterInteractListener, AboutUsInfoInteractListener {
    var viewRouter: UserInfoCenterViewableRouting? { get set }
    var listener: UserInfoCenterInteractListener? { get set }
}

protocol UserInfoCenterViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class UserInfoCenterViewableRouter: MolueViewableRouting {
    
    weak var interactor: UserInfoCenterRouterInteractable?
    
    weak var controller: UserInfoCenterViewControllable?
    
    @discardableResult
    required init(interactor: UserInfoCenterRouterInteractable, controller: UserInfoCenterViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension UserInfoCenterViewableRouter: UserInfoCenterViewableRouting {
    func pushToMessageCenterController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = MessageCenterComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToAboutUsInfoController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = AboutUsInfoComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

class UserInfoCenterComponentBuilder: MolueComponentBuilder, UserInfoCenterComponentBuildable {
    func build(listener: UserInfoCenterInteractListener) -> UIViewController {
        let controller = UserInfoCenterViewController()
        let interactor = UserInfoCenterPageInteractor(presenter: controller)
        UserInfoCenterViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = UserInfoCenterViewController.initializeFromStoryboard()
        let interactor = UserInfoCenterPageInteractor(presenter: controller)
        UserInfoCenterViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
