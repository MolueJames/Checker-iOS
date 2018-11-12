//
//  QuickCheckRiskBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import Gallery

protocol QuickCheckRiskRouterInteractable: class {
    var viewRouter: QuickCheckRiskViewableRouting? { get set }
    var listener: QuickCheckRiskInteractListener? { get set }
}

protocol QuickCheckRiskViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
    func setTakePhotoConfigure(for controller: GalleryController)
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
    func pushToTakePhotoController() {
        do {
            let navigator = try self.controller.unwrap()
            let controller = GalleryController()
            navigator.setTakePhotoConfigure(for: controller)
            navigator.presentViiewController(controller, animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushToScanQRCodeController() {
        
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
