//
//  PotentialRiskBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol PotentialRiskRouterInteractable: HiddenPerilListInteractListener {
    var viewRouter: PotentialRiskViewableRouting? { get set }
    var listener: PotentialRiskInteractListener? { get set }
}

protocol PotentialRiskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
    func setPerilListControllers(with viewControllers: [UIViewController])
}

final class PotentialRiskViewableRouter: MolueViewableRouting {
    
    weak var interactor: PotentialRiskRouterInteractable?
    
    weak var controller: PotentialRiskViewControllable?
    
    @discardableResult
    required init(interactor: PotentialRiskRouterInteractable, controller: PotentialRiskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension PotentialRiskViewableRouter: PotentialRiskViewableRouting {
    func createPerilListController() {
        do {
            let controllers = self.generatePerilListControllers()
            let controller = try self.controller.unwrap()
            controller.setPerilListControllers(with: controllers)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func generatePerilListControllers() -> [UIViewController] {
        return PotentialRiskStatus.allCases.compactMap({ (status) in
            return self.createPerilList(with: status)
        })
    }
    
    func createPerilList(with status: PotentialRiskStatus) -> UIViewController? {
        do {
            let builder = HiddenPerilListComponentBuilder()
            let listener = try self.interactor.unwrap()
            return builder.build(listener: listener, status: status)
        } catch { return MolueLogger.UIModule.allowNil(error) }
    }
}

class PotentialRiskComponentBuilder: MolueComponentBuilder, PotentialRiskComponentBuildable {
    func build(listener: PotentialRiskInteractListener) -> UIViewController {
        let controller = PotentialRiskViewController.initializeFromStoryboard()
        let interactor = PotentialRiskPageInteractor(presenter: controller)
        PotentialRiskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
