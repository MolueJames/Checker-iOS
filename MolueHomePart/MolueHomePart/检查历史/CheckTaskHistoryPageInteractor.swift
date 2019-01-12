//
//  CheckTaskHistoryPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueFoundation
import MolueUtilities

protocol CheckTaskHistoryViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToCheckTaskReportController()
    
    func pushToDailyCheckTaskController()
}

protocol CheckTaskHistoryPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol, MolueActivityDelegate {
    var listener: CheckTaskHistoryPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadCheckTaskHistory()
    
    func reloadDailyTaskHistory()
    
    func reloadTableViewCell(with indexPath: IndexPath)
}

final class CheckTaskHistoryPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskHistoryPagePresentable?
    
    var viewRouter: CheckTaskHistoryViewableRouting?
    
    weak var listener: CheckTaskHistoryInteractListener?
    
    var listModel = MolueListItem<MLCheckTaskHistory>()
    
    var taskList = MolueListItem<MLDailyCheckTask>()
    
    var currentTask: MLDailyCheckTask?
    
    var selectedIndexPath: IndexPath?
    
    var selectedCheckTask: String?
    
    required init(presenter: CheckTaskHistoryPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskHistoryPageInteractor: CheckTaskHistoryRouterInteractable {

}

extension CheckTaskHistoryPageInteractor: CheckTaskHistoryPresentableListener {
    func reloadCheckTask(with task: MLDailyCheckTask) {
        do {
            let indexPath = try self.selectedIndexPath.unwrap()
            self.taskList.replace(with: task, index: indexPath.row)
            let presenter = try self.presenter.unwrap()
            presenter.reloadTableViewCell(with: indexPath)
        } catch {
            MolueLogger.database.message(error)
        }
    }
    
    func jumpToTaskReportController(with indexPath: IndexPath) {
        do {
            let task = self.queryDailyTask(with: indexPath)
            self.currentTask = try task.unwrap()
            try self.jumpToTaskDetail(with: task.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        self.selectedIndexPath = indexPath
    }
    

    func jumpToTaskDetail(with task: MLDailyCheckTask) {
        self.selectedCheckTask = task.taskId
        do {
            let router = try self.viewRouter.unwrap()
            if task.status == "pending" {
                router.pushToDailyCheckTaskController()
            } else {
                router.pushToCheckTaskReportController()
            }
//            router.pushToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let results = self.taskList.results
            return try results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryDailyTask(with indexPath: IndexPath) -> MLDailyCheckTask? {
        do {
            let results = try self.taskList.results.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryTaskHistory(with date: Date) -> MLCheckTaskHistory? {
        do {
            let results = try self.listModel.results.unwrap()
            let histories = results.filter { (history) -> Bool in
                let matched =  date.string(withFormat: "yyyy-MM-dd")
                return history.date == matched
            }
            return try histories.first.unwrap()
        } catch { return nil }
    }
    
    func queryCheckTaskHistory(with startDate: Date, endDate: Date) {
        let started = startDate.string(withFormat: "yyyy-MM-dd")
        let endDate = endDate.string(withFormat: "yyyy-MM-dd")
        let request = MolueCheckService.queryCheckTaskHistory(with: started, endDate: endDate)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLCheckTaskHistory>?) in
            do {
                let strongSelf = try self.unwrap()
                try strongSelf.handleSuccessResult(with: item.unwrap())
            } catch { MolueLogger.network.message(error) }
        }
        let requestManager = MolueRequestManager(delegate: self.presenter)
        requestManager.doRequestStart(with: request)
    }
    
    func handleSuccessResult(with result: MolueListItem<MLCheckTaskHistory>?) {
        do {
            self.listModel = try result.unwrap()
            let presenter = try self.presenter.unwrap()
            presenter.reloadCheckTaskHistory()
        } catch { MolueLogger.network.message(error) }
    }
    
    func queryDailyTaskHistory(with created: Date) {
        let created = created.string(withFormat: "yyyy-MM-dd")
        let request = MolueCheckService.queryDailyTaskHistory(with: created)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLDailyCheckTask>?) in
            do {
                let strongSelf = try self.unwrap()
                try strongSelf.handleSuccessResult(with: item.unwrap())
            } catch { MolueLogger.network.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                let strongSelf = try self.unwrap()
                strongSelf.handleFailureQueryTaskHistory(with: error)
            } catch { MolueLogger.network.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    func handleFailureQueryTaskHistory(with error: Error) {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showWarningHUD(text: "未能获取该天的历史记录")
        } catch { MolueLogger.network.message(error) }
    }
    
    func handleSuccessResult(with result: MolueListItem<MLDailyCheckTask>?) {
        do {
            self.taskList = try result.unwrap()
            let presenter = try self.presenter.unwrap()
            presenter.reloadDailyTaskHistory()
        } catch { MolueLogger.network.message(error) }
    }
}
