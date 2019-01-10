//
//  FailureTaskListPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import RxSwift
import MolueCommon
import MolueUtilities
import MolueMediator

protocol FailureTaskListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToEditRiskInfoController()
}

protocol FailureTaskListPagePresentable: MolueInteractorPresentable {
    var listener: FailureTaskListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class FailureTaskListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: FailureTaskListPagePresentable?
    
    var viewRouter: FailureTaskListViewableRouting?
    
    weak var listener: FailureTaskListInteractListener?
    
    lazy var currentCheckTask: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.selectedCheckTask.unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    lazy var failureItems: [MLTaskAttachment]? = {
        do {
            let checkTask = try self.currentCheckTask.unwrap()
            let attachments = try checkTask.items.unwrap()
            let result: [MLTaskAttachment] = attachments.filter({ (item) -> Bool in
                return item.result != item.rightAnswer
            })
            return result
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    private let disposeBag = DisposeBag()
    
    private var indexPath: IndexPath?
    
    lazy var detailRisk: MLRiskPointDetail? = {
        do {
            let currentTask = try self.currentCheckTask.unwrap()
            return try currentTask.risk.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    var attachment: MLTaskAttachment?
    
    required init(presenter: FailureTaskListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
    
}

extension FailureTaskListPageInteractor: FailureTaskListRouterInteractable {
    
    
}

extension FailureTaskListPageInteractor: FailureTaskListPresentableListener {
    func postCheckFinishNotification() {
        let name = MolueNotification.check_task_finish.toName()
        NotificationCenter.default.post(name: name, object: self.currentCheckTask)
    }
    
    func queryRiskCommand() -> PublishSubject<FailureAttachment> {
        let command = PublishSubject<FailureAttachment>()
        command.subscribe(onNext: { [unowned self] (attachment, indexPath) in
            self.doAddRiskOperation(with: attachment, indexPath: indexPath)
        }).disposed(by: self.disposeBag)
        return command
    }
    
    private func doAddRiskOperation(with attachment: MLTaskAttachment, indexPath: IndexPath) {
        self.attachment = attachment
        self.indexPath = indexPath
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToEditRiskInfoController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func numberOfRows() -> Int? {
        do {
            let attachments = try self.failureItems.unwrap()
            return attachments.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment? {
        do {
            let attachments = try self.failureItems.unwrap()
            return try attachments.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskUnitName() -> String {
        do {
            let task = try self.currentCheckTask.unwrap()
            let riskUnit = try task.risk.unwrap()
            return try riskUnit.unitName.unwrap()
        } catch { return "问题检查项列表" }
    }
}
