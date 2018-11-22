//
//  HomeInfoPageBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol HomeInfoPageRouterInteractable: DangerUnitListInteractListener, RiskCheckTaskInteractListener {
    var viewRouter: HomeInfoPageViewableRouting? { get set }
    var listener: HomeInfoPageInteractListener? { get set }
}

protocol HomeInfoPageViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class HomeInfoPageViewableRouter: MolueViewableRouting {
    
    weak var interactor: HomeInfoPageRouterInteractable?
    
    weak var controller: HomeInfoPageViewControllable?
    
    @discardableResult
    required init(interactor: HomeInfoPageRouterInteractable, controller: HomeInfoPageViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension HomeInfoPageViewableRouter: HomeInfoPageViewableRouting {
    func pushToRiskHistoryController() {
        
    }
    
    func pushToDangerListController() {
        
    }
    
    func pushToDailyTaskController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = DangerUnitListComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToRiskCheckController() {
//        do {
//            let listener = try self.interactor.unwrap()
//            let builder = RiskCheckTaskComponentBuilder()
//            let controller = builder.build(listener: listener)
//            controller.hidesBottomBarWhenPushed = true
//            let navigator = try self.controller.unwrap()
//            navigator.pushToViewController(controller, animated: true)
//        } catch {
//            MolueLogger.UIModule.error(error)
//        }
    }
    
    func pushToNoticationController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = PolicyNoticeViewController.initializeFromStoryboard()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToLegislationController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = LawRegulationViewController.initializeFromStoryboard()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToEducationController() {
        
    }
    
    func pushToDataRecordController() {
        
    }
}

class HomeInfoPageComponentBuilder: MolueComponentBuilder, HomeInfoPageComponentBuildable {
    func build(listener: HomeInfoPageInteractListener) -> UIViewController {
        let controller = HomeInfoPageViewController.initializeFromStoryboard()
        let interactor = HomeInfoPagePageInteractor(presenter: controller)
        HomeInfoPageViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = HomeInfoPageViewController.initializeFromStoryboard()
        let interactor = HomeInfoPagePageInteractor(presenter: controller)
        HomeInfoPageViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
