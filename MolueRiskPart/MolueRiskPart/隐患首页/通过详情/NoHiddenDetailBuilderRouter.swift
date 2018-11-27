//
//  NoHiddenDetailBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon

protocol NoHiddenDetailRouterInteractable: class {
    var viewRouter: NoHiddenDetailViewableRouting? { get set }
    var listener: NoHiddenDetailInteractListener? { get set }
}

protocol NoHiddenDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class NoHiddenDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: NoHiddenDetailRouterInteractable?
    
    weak var controller: NoHiddenDetailViewControllable?
    
    @discardableResult
    required init(interactor: NoHiddenDetailRouterInteractable, controller: NoHiddenDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension NoHiddenDetailViewableRouter: NoHiddenDetailViewableRouting {
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

class NoHiddenDetailComponentBuilder: MolueComponentBuilder, NoHiddenDetailComponentBuildable {
    func build(listener: NoHiddenDetailInteractListener) -> UIViewController {
        let controller = NoHiddenDetailViewController.initializeFromStoryboard()
        let interactor = NoHiddenDetailPageInteractor(presenter: controller)
        NoHiddenDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
