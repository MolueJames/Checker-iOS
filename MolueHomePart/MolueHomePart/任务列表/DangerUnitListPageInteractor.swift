//
//  DangerUnitListPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueNetwork

protocol DangerUnitListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToDailyCheckTaskController()
}

protocol DangerUnitListPagePresentable: MolueInteractorPresentable {
    var listener: DangerUnitListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func popBackWhenTaskChecked()
}

final class DangerUnitListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DangerUnitListPagePresentable?
    
    var viewRouter: DangerUnitListViewableRouting?
    
    weak var listener: DangerUnitListInteractListener?
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    var valueList: [String] = ["1", "2", "2", "2", "2", "2", "2"]
    
    required init(presenter: DangerUnitListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DangerUnitListPageInteractor: DangerUnitListRouterInteractable {
    func popBackControllerWhenChecked() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.popBackWhenTaskChecked()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DangerUnitListPageInteractor: DangerUnitListPresentableListener {
    func queryDailyCheckDangerUnit() {
        let request = MolueCheckService.queryDailyPlanList(page: 1, pagesize: 1)
        request.handleSuccessResponse { (result) in
            MolueLogger.network.message(result)
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    func jumpToDailyCheckTaskController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
