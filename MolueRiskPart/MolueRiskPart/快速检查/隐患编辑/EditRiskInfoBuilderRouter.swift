//
//  EditRiskInfoBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon
import Gallery

protocol EditRiskInfoRouterInteractable: GalleryControllerDelegate, SKPhotoBrowserDelegate {
    var viewRouter: EditRiskInfoViewableRouting? { get set }
    var listener: EditRiskInfoInteractListener? { get set }
}

protocol EditRiskInfoViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class EditRiskInfoViewableRouter: MolueViewableRouting {
    
    weak var interactor: EditRiskInfoRouterInteractable?
    
    weak var controller: EditRiskInfoViewControllable?
    
    @discardableResult
    required init(interactor: EditRiskInfoRouterInteractable, controller: EditRiskInfoViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension EditRiskInfoViewableRouter: EditRiskInfoViewableRouting {
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

protocol EditRiskInfoInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var photoImages: [UIImage]? {get}
}

protocol EditRiskInfoComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: EditRiskInfoInteractListener) -> UIViewController
}

class EditRiskInfoComponentBuilder: MolueComponentBuilder, EditRiskInfoComponentBuildable {
    func build(listener: EditRiskInfoInteractListener) -> UIViewController {
        let controller = EditRiskInfoViewController.initializeFromStoryboard()
        let interactor = EditRiskInfoPageInteractor(presenter: controller)
        EditRiskInfoViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
