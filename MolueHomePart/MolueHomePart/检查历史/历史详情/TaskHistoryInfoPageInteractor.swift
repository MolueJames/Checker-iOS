//
//  TaskHistoryInfoPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator

protocol TaskHistoryInfoViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
    func pushToNoHiddenInfoController()
}

protocol TaskHistoryInfoPagePresentable: MolueInteractorPresentable {
    var listener: TaskHistoryInfoPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class TaskHistoryInfoPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: TaskHistoryInfoPagePresentable?
    
    var viewRouter: TaskHistoryInfoViewableRouting?
    
    weak var listener: TaskHistoryInfoInteractListener?
    
    required init(presenter: TaskHistoryInfoPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
    var selectedRisk: PotentialRiskModel?
    
    var noHiddenItem: TaskSuccessModel?
    
    lazy var taskItem: DangerUnitRiskModel? = {
        return self.listener?.taskItem
    }()
}

extension TaskHistoryInfoPageInteractor: TaskHistoryInfoRouterInteractable {
    
}

extension TaskHistoryInfoPageInteractor: TaskHistoryInfoPresentableListener {
    func jumpToHistoryDetailController(with item: RiskMeasureModel) {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            if item.measureState {
                self.noHiddenItem = try item.taskModel.unwrap()
                viewRouter.pushToNoHiddenInfoController()
            } else {
                self.selectedRisk = try item.riskModel.unwrap()
                viewRouter.pushToRiskDetailController()
            }
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
