//
//  BookDetailsBuilderRouter.swift
//  MolueBookPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol BookDetailsRouterInteractable: class {
    var viewRouter: BookDetailsViewableRouting? { get set }
    var listener: BookDetailsInteractListener? { get set }
}

protocol BookDetailsViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class BookDetailsViewableRouter: MolueViewableRouting {
    
    weak var interactor: BookDetailsRouterInteractable?
    
    weak var controller: BookDetailsViewControllable?
    
    @discardableResult
    required init(interactor: BookDetailsRouterInteractable, controller: BookDetailsViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension BookDetailsViewableRouter: BookDetailsViewableRouting {
    
}

protocol BookDetailsInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
}

protocol BookDetailsComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: BookDetailsInteractListener) -> UIViewController
}

class BookDetailsComponentBuilder: MolueComponentBuilder, BookDetailsComponentBuildable {
    func build(listener: BookDetailsInteractListener) -> UIViewController {
        let controller = BookDetailsViewController.initializeFromStoryboard()
        let interactor = BookDetailsPageInteractor(presenter: controller)
        BookDetailsViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
