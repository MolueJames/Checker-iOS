//
//  BookInfoBuilderRouter.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol BookInfoRouterInteractable: class {
    var viewRouter: BookInfoViewableRouting? { get set }
    var listener: BookInfoInteractListener? { get set }
}

protocol BookInfoViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class BookInfoViewableRouter: MolueViewableRouting {
    
    weak var interactor: BookInfoRouterInteractable?
    
    weak var controller: BookInfoViewControllable?
    
    @discardableResult
    required init(interactor: BookInfoRouterInteractable, controller: BookInfoViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension BookInfoViewableRouter: BookInfoViewableRouting {
    
}

class BookInfoComponentBuilder: MolueComponentBuilder, BookInfoComponentBuildable {
    func build(listener: BookInfoInteractListener) -> UIViewController {
        let controller = BookInfoViewController.initializeFromStoryboard()
        let interactor = BookInfoPageInteractor(presenter: controller)
        BookInfoViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
    
    func build() -> UIViewController {
        let controller = BookInfoViewController.initializeFromStoryboard()
        let interactor = BookInfoPageInteractor(presenter: controller)
        BookInfoViewableRouter(interactor: interactor, controller: controller)
        return controller
    }
}
