//
//  NoHiddenRiskBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/23.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon
import Gallery

protocol NoHiddenRiskRouterInteractable: GalleryControllerDelegate, SKPhotoBrowserDelegate {
    var viewRouter: NoHiddenRiskViewableRouting? { get set }
    var listener: NoHiddenRiskInteractListener? { get set }
}

protocol NoHiddenRiskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class NoHiddenRiskViewableRouter: MolueViewableRouting {
    
    weak var interactor: NoHiddenRiskRouterInteractable?
    
    weak var controller: NoHiddenRiskViewControllable?
    
    @discardableResult
    required init(interactor: NoHiddenRiskRouterInteractable, controller: NoHiddenRiskViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension NoHiddenRiskViewableRouter: NoHiddenRiskViewableRouting {
    func popToPreviewController() {
        do {
            let navigator = try self.controller.unwrap()
            navigator.doPopBackFromCurrent()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToTakePhotoController(with limit: Int) {
        do {
            let navigator = try self.controller.unwrap()
            let controller = GalleryController()
            Config.tabsToShow = [.cameraTab, .imageTab]
            Config.Camera.imageLimit = limit
            controller.delegate = self.interactor
            navigator.doPresentController(controller, animated: false, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToPhotoBrowser(with photos: [SKPhoto], index: Int) {
        do {
            let navigator = try self.controller.unwrap()
            let browser = SKPhotoBrowser(photos: photos)
            browser.initializePageIndex(index)
            browser.delegate = self.interactor
            navigator.doPresentController(browser, animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToPhotoBrowser(with photos: [SKPhoto], controller: UIViewController) {
        let browser = SKPhotoBrowser(photos: photos)
        browser.initializePageIndex(0)
        browser.delegate = self.interactor
        controller.present(browser, animated: true, completion: nil)
    }
}

class NoHiddenRiskComponentBuilder: MolueComponentBuilder, NoHiddenRiskComponentBuildable {
    func build(listener: NoHiddenRiskInteractListener) -> UIViewController {
        let controller = NoHiddenRiskViewController.initializeFromStoryboard()
        let interactor = NoHiddenRiskPageInteractor(presenter: controller)
        NoHiddenRiskViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
