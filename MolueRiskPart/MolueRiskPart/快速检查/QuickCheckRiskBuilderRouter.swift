//
//  QuickCheckRiskBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon

protocol QuickCheckRiskRouterInteractable: EditRiskInfoInteractListener, SWScanQRCodeProtocol, DailyCheckTaskInteractListener {
    var viewRouter: QuickCheckRiskViewableRouting? { get set }
    var listener: QuickCheckRiskInteractListener? { get set }
}

protocol QuickCheckRiskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class QuickCheckRiskViewableRouter: MolueViewableRouting {
    
    weak var interactor: QuickCheckRiskRouterInteractable?
    
    weak var controller: QuickCheckRiskViewControllable?
    
    @discardableResult
    required init(interactor: QuickCheckRiskRouterInteractable, controller: QuickCheckRiskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension QuickCheckRiskViewableRouter: QuickCheckRiskViewableRouting {
    
    func pushToDailyCheckController() {
        do {
            let navigator = try self.controller.unwrap()
            let builderFactory = MolueBuilderFactory<MolueComponent.Home>(.DailyCheck)
            let builder: DailyCheckTaskComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: self.interactor.unwrap())
            controller.hidesBottomBarWhenPushed = true
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToEditRiskController() {
        do {
            let builder: EditRiskInfoComponentBuildable = EditRiskInfoComponentBuilder()
            let controller = try builder.build(listener: self.interactor.unwrap())
            let navigator = try self.controller.unwrap()
            controller.hidesBottomBarWhenPushed = true
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    
    func pushToScanQRCodeController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = SWQRCodeViewController()
            controller.delegate = self.interactor
            controller.hidesBottomBarWhenPushed = true
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

class QuickCheckRiskComponentBuilder: MolueComponentBuilder, QuickCheckRiskComponentBuildable {
    func build(listener: QuickCheckRiskInteractListener) -> UIViewController {
        let controller = QuickCheckRiskViewController.initializeFromStoryboard()
        let interactor = QuickCheckRiskPageInteractor(presenter: controller)
        QuickCheckRiskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = QuickCheckRiskViewController.initializeFromStoryboard()
        let interactor = QuickCheckRiskPageInteractor(presenter: controller)
        QuickCheckRiskViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
