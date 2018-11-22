//
//  RiskDetailBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon

protocol RiskDetailRouterInteractable: class {
    var viewRouter: RiskDetailViewableRouting? { get set }
    var listener: RiskDetailInteractListener? { get set }
}

protocol RiskDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskDetailRouterInteractable?
    
    weak var controller: RiskDetailViewControllable?
    
    @discardableResult
    required init(interactor: RiskDetailRouterInteractable, controller: RiskDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskDetailViewableRouter: RiskDetailViewableRouting {
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int) {
        do {
            let navigator = try self.controller.unwrap()
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(index)
            SKPhotoBrowserOptions.displayDeleteButton = false
            navigator.doPresentController(browser, animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol RiskDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol RiskDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskDetailInteractListener) -> UIViewController
}

class RiskDetailComponentBuilder: MolueComponentBuilder, RiskDetailComponentBuildable {
    func build(listener: RiskDetailInteractListener) -> UIViewController {
        let controller = RiskDetailViewController.initializeFromStoryboard()
        let interactor = RiskDetailPageInteractor(presenter: controller)
        RiskDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
