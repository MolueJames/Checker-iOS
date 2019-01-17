//
//  RiskArrangeBuilderRouter.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator
import MolueCommon
import RxSwift

protocol RiskArrangeRouterInteractable: class {
    var viewRouter: RiskArrangeViewableRouting? { get set }
    var listener: RiskArrangeInteractListener? { get set }
}

protocol RiskArrangeViewControllable: MolueViewControllable {
    // 定义一些该页面需要的其他commponent的组件, 比如该页面的childViewController等.
}

final class RiskArrangeViewableRouter: MolueViewableRouting {
    
    weak var interactor: RiskArrangeRouterInteractable?
    
    weak var controller: RiskArrangeViewControllable?
    
    @discardableResult
    required init(interactor: RiskArrangeRouterInteractable, controller: RiskArrangeViewControllable) {
        self.controller = controller
        self.interactor = interactor
        interactor.viewRouter = self
    }
}

extension RiskArrangeViewableRouter: RiskArrangeViewableRouting {

    func presentDatePicker(with command: PublishSubject<(date: Date, string: String)>) {
        do {
            let navigator = try self.controller.unwrap()
            let controller = MLDatePickerViewController.initializeFromStoryboard()
            controller.modalPresentationStyle = .overCurrentContext
            controller.selectDateCommand = command
            navigator.doPresentController(controller, animated: true, completion: nil)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

protocol RiskArrangeInteractListener: class {
    //用于定义其他的Component需要定义的协议方法
    var hiddenPeril: MLHiddenPerilItem? { get }
}

protocol RiskArrangeComponentBuildable: MolueComponentBuildable {
    //定义当前的Component的构造方法.
    func build(listener: RiskArrangeInteractListener) -> UIViewController
}

class RiskArrangeComponentBuilder: MolueComponentBuilder, RiskArrangeComponentBuildable {
    func build(listener: RiskArrangeInteractListener) -> UIViewController {
        let controller = RiskArrangeViewController.initializeFromStoryboard()
        let interactor = RiskArrangePageInteractor(presenter: controller)
        RiskArrangeViewableRouter(interactor: interactor, controller: controller)
        interactor.listener = listener
        return controller
    }
}
