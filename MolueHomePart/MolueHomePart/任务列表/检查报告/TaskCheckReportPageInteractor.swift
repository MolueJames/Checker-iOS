//
//  TaskCheckReportPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol TaskCheckReportViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol TaskCheckReportPagePresentable: MolueInteractorPresentable {
    var listener: TaskCheckReportPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class TaskCheckReportPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: TaskCheckReportPagePresentable?
    
    var viewRouter: TaskCheckReportViewableRouting?
    
    weak var listener: TaskCheckReportInteractListener?
    
    lazy var currentCheckTask: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.currentCheckTask.unwrap()
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
    func numberOfRows(in section: Int) -> Int? {
        let attachmentCount = self.numberOfAttachments()
        return section == 0 ? attachmentCount : 2
    }
    
    func numberOfAttachments() -> Int? {
        do {
            let attachments = try self.taskAttachments.unwrap()
            return attachments.count
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
