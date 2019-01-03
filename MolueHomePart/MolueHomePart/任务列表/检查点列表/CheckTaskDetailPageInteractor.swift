//
//  CheckTaskDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator
import MolueNetwork
import MolueCommon
import MolueFoundation

protocol CheckTaskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushTaskCheckDetailController()
    
    func jumpToFailureTaskListController()
    
    func presentAlertController(with finished: UIAlertAction, addRisks: UIAlertAction)
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol , MolueActivityDelegate {
    var listener: CheckTaskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
    func reloadTableViewCell(for indexPath: IndexPath)
}

final class CheckTaskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskDetailPagePresentable?
    
    var viewRouter: CheckTaskDetailViewableRouting?
    
    weak var listener: CheckTaskDetailInteractListener?
    
    lazy var selectedCheckTask: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.currentCheckTask.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    private var currentIndexPath: IndexPath?
    
    var currentAttachment: MLTaskAttachment?
    
    required init(presenter: CheckTaskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailRouterInteractable {
    
    func updateCurrentAttachment(with item: MLTaskAttachment) {
        do {
            let indexPath = try self.currentIndexPath.unwrap()
            self.updateAttachment(with: item, indexPath: indexPath)
            let presenter = try self.presenter.unwrap()
            presenter.reloadTableViewCell(for: indexPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailPresentableListener {
    func queryCheckTaskName() -> String {
        do {
            let task = try self.selectedCheckTask.unwrap()
            return try task.risk.unwrap().unitName.unwrap()
        } catch { return "任务详情" }
    }
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment? {
        do {
            let task = try self.selectedCheckTask.unwrap()
            let attachments = try task.items.unwrap()
            let item = attachments.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }
    
    func updateAttachmentClosures(for cell: CheckTaskDetailTableViewCell) {
        cell.detailClosure = { [unowned self] (attachment, indexPath) in
            self.jumpToAttachment(with: attachment, indexPath: indexPath)
        }
        
        cell.updateClosure = { [unowned self] (attachment, indexPath) in
            self.updateAttachment(with: attachment, indexPath: indexPath)
        }
    }
    
    private func jumpToAttachment(with attachment: MLTaskAttachment, indexPath: IndexPath) {
        do {
            self.currentAttachment = attachment
            self.currentIndexPath = indexPath
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushTaskCheckDetailController()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    private func updateAttachment(with attachment: MLTaskAttachment, indexPath: IndexPath)  {
        do {
            let task = try self.selectedCheckTask.unwrap()
            var attachments = try task.items.unwrap()
            attachments[indexPath.row] = attachment
            try self.selectedCheckTask.unwrap().items = attachments
            let presenter = try self.presenter.unwrap()
            presenter.reloadTableViewCell(for: indexPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func queryTaskSolution(with indexPath: IndexPath) -> MLRiskUnitSolution? {
        do {
            let currentTask = try self.selectedCheckTask.unwrap()
            let currentRisk = try currentTask.risk.unwrap()
            let solutions = try currentRisk.solutions.unwrap()
            return try solutions.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func postCheckTaskDetailToServer() {
        do {
            let checkTask = try self.selectedCheckTask.unwrap()
            if try self.isAllTaskChecked(with: checkTask.items.unwrap()) {
                let taskId = try checkTask.taskId.unwrap()
                self.updateCheckTask(with: taskId, parameters: checkTask.toJSON())
            } else {
                let presenter = try self.presenter.unwrap()
                presenter.showWarningHUD(text: "尚有未完成的检查项")
            }
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func updateCheckTask(with taskId: String, parameters: [String : Any]) {
        let request = MolueCheckService.updateDailyCheckTask(with: taskId, paramaters: parameters)
        request.handleSuccessResultToObjc { [weak self](result: MLDailyCheckTask?) in
            do {
                let checkTask = try result.unwrap()
                try self.unwrap().handleSuccessOpertaion(with: checkTask)
            } catch { MolueLogger.network.message(error) }
        }
        let requestManager = MolueRequestManager(delegate: self.presenter)
        requestManager.doRequestStart(with: request)
    }
    
    func isAllTaskChecked(with attachments: [MLTaskAttachment])  -> Bool {
        return !attachments.contains(where: { (item) -> Bool in
            return item.result.isNone()
        })
    }
    
    func handleSuccessOpertaion(with result: MLDailyCheckTask) {
        if result.status == "risky" {
            self.presentChoiceController(with: result)
        } else {
            self.doFinishedOperation(with: result)
        }
    }
    
    func presentChoiceController(with result: MLDailyCheckTask) {
        do {
            let finished = UIAlertAction(title: "完成检查", style: .default) { [unowned self] _ in
                self.doFinishedOperation(with: result)
            }
            let addRisks = UIAlertAction(title: "添加隐患", style: .destructive) { [unowned self] _ in
                self.doAddRisksOperation(with: result)
            }
            let router = try self.viewRouter.unwrap()
            router.presentAlertController(with: finished, addRisks: addRisks)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    private func doFinishedOperation(with result: MLDailyCheckTask) {
        let name = MolueNotification.check_task_finish.toName()
        NotificationCenter.default.post(name: name, object: result)
    }
    
    private func doAddRisksOperation(with result: MLDailyCheckTask) {
        do {
            let router = try self.viewRouter.unwrap()
            router.jumpToFailureTaskListController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let currentTask = try self.selectedCheckTask.unwrap()
            let currentRisk = try currentTask.risk.unwrap()
            let solutions = try currentRisk.solutions.unwrap()
            return solutions.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
