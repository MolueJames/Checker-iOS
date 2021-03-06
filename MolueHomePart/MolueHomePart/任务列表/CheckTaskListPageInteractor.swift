//
//  CheckTaskListPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueFoundation
import MolueNetwork

protocol CheckTaskListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToDailyCheckTaskController()
}

protocol CheckTaskListPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: CheckTaskListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func popBackWhenTaskChecked()
    
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
    
    func reloadTableViewCell(with indexPath: IndexPath)
}

final class CheckTaskListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskListPagePresentable?
    
    var viewRouter: CheckTaskListViewableRouting?
    
    weak var listener: CheckTaskListInteractListener?
    
    var selectedCheckTask: String?
    
    private var selectedIndexPath: IndexPath?
    
    var listModel = MolueListItem<MLDailyCheckPlan>()
    
    required init(presenter: CheckTaskListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskListPageInteractor: CheckTaskListRouterInteractable {

}

extension CheckTaskListPageInteractor: CheckTaskListPresentableListener {
    func reloadCheckTask(with task: MLDailyCheckTask) {
        do {
            let indexPath = try self.selectedIndexPath.unwrap()
            let presenter = try self.presenter.unwrap()
            self.updateCheckTask(with: task, at: indexPath)
            presenter.reloadTableViewCell(with: indexPath)
        } catch {
            MolueLogger.database.message(error)
        }
    }
    
    func updateCheckTask(with task: MLDailyCheckTask, at indexPath: IndexPath) {
        var tasks = self.listModel.results?[indexPath.section].tasks
        tasks?[indexPath.row] = task
        self.listModel.results?[indexPath.section].tasks = tasks
    }
    
    func jumpToCheckTaskDetail(with indexPath: IndexPath) {
        do {
            self.selectedIndexPath = indexPath
            let checkTask = self.queryTaskItem(with: indexPath)
            self.selectedCheckTask = try checkTask.unwrap().taskId
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func moreDailyCheckDangerUnit() {
        do {
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.qureyMoreDailyPlanItem(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func qureyMoreDailyPlanItem(with page: Int, size: Int) {
        let request = MolueCheckService.queryDailyPlanList(page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLDailyCheckPlan>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handlePlanList(with: error, isMore: true)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleMoreItems(_ listModel :MolueListItem<MLDailyCheckPlan>?) {
        do {
            try self.listModel.append(with: listModel)
        } catch { MolueLogger.UIModule.message(error)}
        
        let hasNext = listModel?.next.isSome() ?? false
        self.presenter?.endFooterRefreshing(with: hasNext)
        self.presenter?.reloadTableViewData()
    }
    
    func queryTaskItem(with indexPath: IndexPath) -> MLDailyCheckTask? {
        do {
            let plan = self.queryPlanItem(with: indexPath.section)
            let tasks = try plan.unwrap().tasks.unwrap()
            return try tasks.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfSections() -> Int? {
        do {
            let results = self.listModel.results
            return try results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let plan = self.queryPlanItem(with: section)
            let tasks = try plan.unwrap().tasks.unwrap()
            return tasks.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryPlanItem(with section: Int) -> MLDailyCheckPlan? {
        do {
            let results = self.listModel.results
            let itemList = try results.unwrap()
            return try itemList.item(at: section).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryDailyCheckDangerUnit() {
        let size: Int = self.listModel.pagesize
        let request = MolueCheckService.queryDailyPlanList(page: 1, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLDailyCheckPlan>?) in
            do {
                try self.unwrap().handleQueryItem(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handlePlanList(with: error, isMore: false)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleQueryItem(_ listModel: MolueListItem<MLDailyCheckPlan>?) {
        do {
            try self.listModel = listModel.unwrap()
        } catch { MolueLogger.network.message(error) }
        self.presenter?.endHeaderRefreshing()
        self.presenter?.reloadTableViewData()
    }
    
    private func handlePlanList(with error: Error, isMore: Bool) {
        do {
            let presenter = try self.presenter.unwrap()
            if isMore {
                presenter.endFooterRefreshing(with: true)
            } else {
                presenter.endHeaderRefreshing()
            }
            presenter.showWarningHUD(text: error.localizedDescription)
        } catch { MolueLogger.UIModule.error(error) }
    }
}
