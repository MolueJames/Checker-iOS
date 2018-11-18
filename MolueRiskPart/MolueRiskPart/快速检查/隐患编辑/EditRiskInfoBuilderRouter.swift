//
//  EditRiskInfoBuilderRouter.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/17.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol EditRiskInfoRouterInteractable: class {
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
