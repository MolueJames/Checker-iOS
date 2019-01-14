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
    func pushToHiddenPerilController()
}

protocol TaskCheckReportPagePresentable: MolueInteractorPresentable, MolueActivityDelegate, MLControllerHUDProtocol {
    var listener: TaskCheckReportPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
    func reloadTableViewData()
    
    func endHeaderRefreshing()
}

final class TaskCheckReportPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: TaskCheckReportPagePresentable?
    
    var viewRouter: TaskCheckReportViewableRouting?
    
    weak var listener: TaskCheckReportInteractListener?
    
    private var hiddenPerils: [MLHiddenPerilItem]?
    
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
    
    var hiddenPeril: MLHiddenPerilItem?
    
    required init(presenter: TaskCheckReportPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension TaskCheckReportPageInteractor: TaskCheckReportRouterInteractable {

}

extension TaskCheckReportPageInteractor: TaskCheckReportPresentableListener {
    func jumpToHiddenPerilController(with indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        self.hiddenPeril = self.queryHiddenPeril(with: indexPath)
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToHiddenPerilController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryHiddenPeril(with indexPath: IndexPath) -> MLHiddenPerilItem? {
        do {
            let results = try self.hiddenPerils.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRelatedHiddenPerils() {
        do {
            let task = try self.currentCheckTask.unwrap()
            let taskId = try task.taskId.unwrap()
            let request = MoluePerilService.queryHiddenPeril(with: taskId)
            request.handleSuccessResultToList { [weak self] (result: [MLHiddenPerilItem]?) in
                do {
                    let strongSelf = try self.unwrap()
                    strongSelf.handleQueryItem(result)
                } catch { MolueLogger.network.message(error) }
            }
            request.handleFailureResponse { [weak self] (error) in
                do {
                    try self.unwrap().handleHiddenPerils(with: error)
                } catch { MolueLogger.network.message(error) }
            }
            MolueRequestManager().doRequestStart(with: request)
        } catch {
            MolueLogger.network.message(error)
        }
    }
    
    private func handleQueryItem(_ hiddenPerils: [MLHiddenPerilItem]?) {
        do {
            self.hiddenPerils = hiddenPerils
            let presenter = try self.presenter.unwrap()
            presenter.endHeaderRefreshing()
            presenter.reloadTableViewData()
        } catch {
            MolueLogger.network.message(error)
        }
    }
    
    private func handleHiddenPerils(with error: Error) {
        do {
            let presenter = try self.presenter.unwrap()
            let message = error.localizedDescription
            presenter.showWarningHUD(text: message)
            presenter.endHeaderRefreshing()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }

    
    func numberOfRows(in section: Int) -> Int? {
        if section == 0 {
            return self.numberOfAttachments()
        } else {
            return self.numberOfHiddenPeril()
        }
    }
    
    func numberOfHiddenPeril() -> Int? {
        do {
            return try self.hiddenPerils.unwrap().count
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
