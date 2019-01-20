//
//  RiskRectifyBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskRectifyRouterInteractable: RiskDetailInteractListener {
    var viewRouter: RiskRectifyViewableRouting? { get set }
    var listener: RiskRectifyInteractListener? { get set }
}

protocol RiskRectifyViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskRectifyViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskRectifyRouterInteractable?
    
    weak var controller: RiskRectifyViewControllable?
    
    @discardableResult
    required init(interactor: RiskRectifyRouterInteractable, controller: RiskRectifyViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskRectifyViewableRouter: RiskRectifyViewableRouting {
    func pushToRiskDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch { MolueLogger.UIModule.error(error) }
    }
}

protocol RiskRectifyInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var hiddenPeril: MLHiddenPerilItem? { get }
}

protocol RiskRectifyComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskRectifyInteractListener) -> UIViewController
}

class RiskRectifyComponentBuilder: MolueComponentBuilder, RiskRectifyComponentBuildable {
    func build(listener: RiskRectifyInteractListener) -> UIViewController {
        let controller = RiskRectifyViewController.initializeFromStoryboard()
        let interactor = RiskRectifyPageInteractor(presenter: controller)
        RiskRectifyViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
