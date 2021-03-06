//
//  HomeInfoPageBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities

protocol HomeInfoPageRouterInteractable: CheckTaskHistoryInteractListener, CheckTaskListInteractListener, PotentialRiskInteractListener, AdvertiseContentInteractListener, RiskUnitListInteractListener {
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
    func pushToRiskUnitListController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = RiskUnitListComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToAdvertisementController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = AdvertiseContentComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToRiskHistoryController() {
        do {
            let listener = try self.interactor.unwrap()
            let builderFactory = MolueBuilderFactory<MolueComponent.Risk>(.RiskList)
            let builder: PotentialRiskComponentBuildable? = builderFactory.queryBuilder()
            let controller = try builder.unwrap().build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToDangerListController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = CheckTaskHistoryComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToDailyTaskController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = CheckTaskListComponentBuilder()
            let controller = builder.build(listener: listener)
            controller.hidesBottomBarWhenPushed = true
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToNoticationController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = PolicyNoticeComponentBuilder().build()
            controller.hidesBottomBarWhenPushed = true
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToLegislationController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = LawRegulationViewController.initializeFromStoryboard()
            controller.hidesBottomBarWhenPushed = true
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
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
