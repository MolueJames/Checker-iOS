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
    
    func reloadTableViewData()
}

final class DangerUnitListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DangerUnitListPagePresentable?
    
    var viewRouter: DangerUnitListViewableRouting?
    
    weak var listener: DangerUnitListInteractListener?
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    var listModel: MolueListItem<MLDailyPlanDetailModel>?
    
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
    func queryRisKItem(with indexPath: IndexPath) -> MLRiskTaskDetailModel? {
        do {
            let plan = self.queryUnitItem(with: indexPath.section)
            let unit = try plan.unwrap().risk_unit.unwrap()
            let itemList = try unit.risks.unwrap()
            return try itemList.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfSections() -> Int? {
        do {
            let listItem = try self.listModel.unwrap()
            return try listItem.results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let item = self.queryUnitItem(with: section)
            let risk_unit = try item.unwrap().risk_unit.unwrap()
            return try risk_unit.risks.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryUnitItem(with section: Int) -> MLDailyPlanDetailModel? {
        do {
            let listItem = try self.listModel.unwrap()
            let itemList = try listItem.results.unwrap()
            return try itemList.item(at: section).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryDailyCheckDangerUnit() {
        let request = MolueCheckService.queryDailyPlanList(page: 1, pagesize: 1)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLDailyPlanDetailModel>?) in
            dump(item)
            do {
                let strongSelf = try self.unwrap()
                strongSelf.listModel = item
                let presenter = try strongSelf.presenter.unwrap()
                presenter.reloadTableViewData()
            } catch {MolueLogger.UIModule.error(error)}
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
