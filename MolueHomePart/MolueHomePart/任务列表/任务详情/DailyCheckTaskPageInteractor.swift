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
}

protocol DailyCheckTaskPagePresentable: MolueInteractorPresentable {
    var listener: DailyCheckTaskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class DailyCheckTaskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DailyCheckTaskPagePresentable?
    
    var viewRouter: DailyCheckTaskViewableRouting?
    
    weak var listener: DailyCheckTaskInteractListener?
    
    var selectedCheckTask: MLDailyCheckTask?

    lazy var currentItem: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.selectedCheckTask.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: DailyCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskRouterInteractable {
    
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskPresentableListener {
    func queryDailyCheckTask() {
        do {
            let taskId = try self.currentItem.unwrap().taskId.unwrap()
            let dataRequest = MolueCheckService.queryDailyCheckTask(with: taskId)
            dataRequest.handleSuccessResponse { (result) in
                dump(result)
                MolueLogger.network.message(result)
            }
            MolueRequestManager().doRequestStart(with: dataRequest)
        } catch { MolueLogger.network.message(error) }
    }
    
    func jumpToCheckTaskDetailController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToCheckTaskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
