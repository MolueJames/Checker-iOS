//
//  DailyCheckTaskPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueCommon
import MolueNetwork
import MolueUtilities

protocol DailyCheckTaskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToCheckTaskDetailController()
    
    func pushToCheckTaskReportController()
}

protocol DailyCheckTaskPagePresentable: MolueInteractorPresentable, MolueActivityDelegate {
    var listener: DailyCheckTaskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
    func refreshSubviews(with task: MLDailyCheckTask)
}

final class DailyCheckTaskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DailyCheckTaskPagePresentable?
    
    var viewRouter: DailyCheckTaskViewableRouting?
    
    weak var listener: DailyCheckTaskInteractListener?
    
    var selectedCheckTask: String?
    
    var currentTask: MLDailyCheckTask?
    
    required init(presenter: DailyCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskRouterInteractable {
    
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskPresentableListener {
    
    func numberOfRows(with sections: Int) -> Int? {
        do {
            let currentTask = try self.currentTask.unwrap()
            let riskUnit = try currentTask.risk.unwrap()
            return try riskUnit.solutions.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func querySolutionItem(with indexPath: IndexPath) -> MLRiskUnitSolution? {
        do {
            let currentTask = try self.currentTask.unwrap()
            let riskUnit = try currentTask.risk.unwrap()
            let solutions = try riskUnit.solutions.unwrap()
            return try solutions.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryDailyCheckTask() {
        do {
            let taskId = try self.listener.unwrap().selectedCheckTask.unwrap()
            let request = MolueCheckService.queryDailyCheckTask(with: taskId)
            request.handleSuccessResultToObjc { [weak self] (result: MLDailyCheckTask?) in
                do {
                    try self.unwrap().handleSuccessResult(with: result)
                } catch { MolueLogger.UIModule.message(error) }
            }
            let requestManager = MolueRequestManager(delegate: self.presenter)
            requestManager.doRequestStart(with: request)
        } catch { MolueLogger.network.message(error) }
    }
    
    func handleSuccessResult(with task: MLDailyCheckTask?) {
        do {
            let currentTask = try task.unwrap()
            self.currentTask = currentTask
            let presenter = try self.presenter.unwrap()
            presenter.refreshSubviews(with: currentTask)
        } catch { MolueLogger.network.message(error) }
    }
    
    func jumpToCheckTaskDetailController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            let currentCheckTask = try self.currentTask.unwrap()
            if currentCheckTask.status == "pending" {
                viewRouter.pushToCheckTaskDetailController()
            } else {
//                viewRouter.pushToCheckTaskReportController()
                viewRouter.pushToCheckTaskDetailController()
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
