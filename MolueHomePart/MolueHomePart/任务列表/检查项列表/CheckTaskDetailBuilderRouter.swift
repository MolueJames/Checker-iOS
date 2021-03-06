//
//  CheckTaskDetailBuilderRouter.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueFoundation
import MolueMediator

protocol CheckTaskDetailRouterInteractable: TaskCheckDetailInteractListener, FailureTaskListInteractListener {
    var viewRouter: CheckTaskDetailViewableRouting? { get set }
    var listener: CheckTaskDetailInteractListener? { get set }
}

protocol CheckTaskDetailViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class CheckTaskDetailViewableRouter: MolueViewableRouting {
    
    weak var interactor: CheckTaskDetailRouterInteractable?
    
    weak var controller: CheckTaskDetailViewControllable?
    
    @discardableResult
    required init(interactor: CheckTaskDetailRouterInteractable, controller: CheckTaskDetailViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension CheckTaskDetailViewableRouter: CheckTaskDetailViewableRouting {
    
    func jumpToFailureTaskListController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = FailureTaskListComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func presentAlertController(with finished: UIAlertAction, addRisks: UIAlertAction) {
        do {
            let alert = UIAlertController(title: "请确认下一步操作", message: nil, preferredStyle: .alert)
            alert.addActions([finished, addRisks])
            let navigator = try self.controller.unwrap()
            navigator.doPresentController(alert, animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func pushTaskCheckDetailController() {
        do {
            let listener = try self.interactor.unwrap()
            let builder = TaskCheckDetailComponentBuilder()
            let controller = builder.build(listener: listener)
            let navigator = try self.controller.unwrap()
            navigator.pushToViewController(controller, animated: true)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol CheckTaskDetailInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var currentTask: MLDailyCheckTask? {get}
}

protocol CheckTaskDetailComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: CheckTaskDetailInteractListener) -> UIViewController
}

class CheckTaskDetailComponentBuilder: MolueComponentBuilder, CheckTaskDetailComponentBuildable {
    func build(listener: CheckTaskDetailInteractListener) -> UIViewController {
        let controller = CheckTaskDetailViewController.initializeFromStoryboard()
        let interactor = CheckTaskDetailPageInteractor(presenter: controller)
        CheckTaskDetailViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
