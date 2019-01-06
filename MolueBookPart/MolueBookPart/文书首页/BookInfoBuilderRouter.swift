//
//  BookInfoBuilderRouter.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol BookInfoRouterInteractable: BookDetailsInteractListener {
    var viewRouter: BookInfoViewableRouting? { get set }
    var listener: BookInfoInteractListener? { get set }
}

protocol BookInfoViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
    func setDetailsControllers(with viewControllers: [UIViewController])
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
    func createBookDetailsController() {
        do {
            let controllers = self.generateDetailsControllers()
            let controller = try self.controller.unwrap()
            controller.setDetailsControllers(with: controllers)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func generateDetailsControllers() -> [UIViewController] {
        var controllers = [UIViewController]()
        controllers.append(self.createBookDetails()!)
        controllers.append(self.createBookDetails()!)
        controllers.append(self.createBookDetails()!)
        return controllers
    }
    
    func createBookDetails() -> UIViewController? {
        do {
            let builder = BookDetailsComponentBuilder()
            let listener = try self.interactor.unwrap()
            return builder.build(listener: listener)
        } catch { return MolueLogger.UIModule.allowNil(error) }
    }
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
