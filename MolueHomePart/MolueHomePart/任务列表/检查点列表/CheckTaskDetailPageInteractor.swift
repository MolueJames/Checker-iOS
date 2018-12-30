//
//  CheckTaskDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator
import MolueFoundation

protocol CheckTaskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToNoHiddenController()
    
    func pushToCheckDetailReport()
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
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
            viewRouter.pushToNoHiddenController()
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
