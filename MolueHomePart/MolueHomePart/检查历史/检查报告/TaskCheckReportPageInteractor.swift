//
//  TaskCheckReportPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueNetwork
import MolueFoundation
import MolueUtilities
import MolueMediator

protocol TaskCheckReportViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol TaskCheckReportPagePresentable: MolueInteractorPresentable, MolueActivityDelegate, MLControllerHUDProtocol {
    var listener: TaskCheckReportPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class TaskCheckReportPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: TaskCheckReportPagePresentable?
    
    var viewRouter: TaskCheckReportViewableRouting?
    
    weak var listener: TaskCheckReportInteractListener?
    
    var listModel = MolueListItem<MLHiddenPerilItem>(3)
    
    lazy var currentCheckTask: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.currentTask.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    lazy var taskAttachments: [MLTaskAttachment]? = {
        do {
            let checkTask = try self.currentCheckTask.unwrap()
            return try checkTask.items.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    required init(presenter: TaskCheckReportPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension TaskCheckReportPageInteractor: TaskCheckReportRouterInteractable {
    
}

extension TaskCheckReportPageInteractor: TaskCheckReportPresentableListener {
    func moreRelatedHiddenPerils() {
        do {
            let task = try self.currentCheckTask.unwrap()
            let riskId = try task.risk.unwrap().unitId.unwrap()
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.queryMoreHiddenPeril(with: riskId, page: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func queryMoreHiddenPeril(with riskId: Int, page: Int, size: Int) {
        let request = MoluePerilService.queryHiddenPeril(with: riskId, page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLHiddenPerilItem>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleHiddenPerils(with: error, isMore: true)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleMoreItems(_ listModel :MolueListItem<MLHiddenPerilItem>?) {
        do {
            try self.listModel.append(with: listModel)
        } catch { MolueLogger.UIModule.message(error)}
        
        let hasNext = listModel?.next.isSome() ?? false
        self.presenter?.endFooterRefreshing(with: hasNext)
        self.presenter?.reloadTableViewData()
    }
    
    func queryHiddenPeril(with indexPath: IndexPath) -> MLHiddenPerilItem? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRelatedHiddenPerils() {
        do {
            let task = try self.currentCheckTask.unwrap()
            let riskId = try task.risk.unwrap().unitId.unwrap()
            let size: Int = self.listModel.pagesize
            let request = MoluePerilService.queryHiddenPeril(with: riskId, page: 1, size: size)
            request.handleSuccessResultToObjc { [weak self] (result: MolueListItem<MLHiddenPerilItem>?) in
                do {
                    let strongSelf = try self.unwrap()
                    strongSelf.handleQueryItem(result)
                } catch { MolueLogger.network.message(error) }
            }
            request.handleFailureResponse { [weak self] (error) in
                do {
                    try self.unwrap().handleHiddenPerils(with: error, isMore: false)
                } catch { MolueLogger.UIModule.message(error) }
            }
            MolueRequestManager().doRequestStart(with: request)
        } catch {
            MolueLogger.network.message(error)
        }
    }
    
    private func handleQueryItem(_ listModel: MolueListItem<MLHiddenPerilItem>?) {
        do {
            try self.listModel = listModel.unwrap()
        } catch { MolueLogger.network.message(error) }
        self.presenter?.endHeaderRefreshing()
        self.presenter?.reloadTableViewData()
    }
    
    private func handleHiddenPerils(with error: Error, isMore: Bool) {
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

    
    func numberOfRows(in section: Int) -> Int? {
        let attachmentsCount = self.numberOfAttachments()
        let hiddenPerilCount = self.numberOfHiddenPeril()
        return section == 0 ? attachmentsCount : hiddenPerilCount
    }
    
    func numberOfHiddenPeril() -> Int? {
        do {
            let results = self.listModel.results
            return try results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfAttachments() -> Int? {
        do {
            let attachments =  self.taskAttachments
            return try attachments.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment? {
        do {
            let attachments = try self.taskAttachments.unwrap()
            return try attachments.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
