//
//  ExistedRiskDetailBuilderRouter.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/11.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator

protocol ExistedRiskDetailRouterInteractable: class {
    var viewRouter: ExistedRiskDetailViewableRouting? { get set }
    var listener: ExistedRiskDetailInteractListener? { get set }
}

protocol ExistedRiskDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class ExistedRiskDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: ExistedRiskDetailRouterInteractable?
    
    weak var controller: ExistedRiskDetailViewControllable?
    
    @discardableResult
    required init(interactor: ExistedRiskDetailRouterInteractable, controller: ExistedRiskDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension ExistedRiskDetailViewableRouter: ExistedRiskDetailViewableRouting {
    func doSubmitButtonClickedRouter() {
        do {
            let navigator = try self.controller.unwrap()
            navigator.doDismiss(animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func doCancelButtonClickedRouter() {
        do {
            let navigator = try self.controller.unwrap()
            navigator.doDismiss(animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol ExistedRiskDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol ExistedRiskDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: ExistedRiskDetailInteractListener) -> UIViewController
}

class ExistedRiskDetailComponentBuilder: MolueComponentBuilder, ExistedRiskDetailComponentBuildable {
    func build(listener: ExistedRiskDetailInteractListener) -> UIViewController {
        let controller = ExistedRiskDetailViewController.initializeFromStoryboard()
        let interactor = ExistedRiskDetailPageInteractor(presenter: controller)
        ExistedRiskDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
