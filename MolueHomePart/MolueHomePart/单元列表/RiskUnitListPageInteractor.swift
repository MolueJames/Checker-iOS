//
//  RiskUnitListPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueNetwork
import MolueFoundation
import MolueUtilities
import MolueMediator

protocol RiskUnitListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskPointListController()
}

protocol RiskUnitListPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: RiskUnitListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class RiskUnitListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskUnitListPagePresentable?
    
    var viewRouter: RiskUnitListViewableRouting?
    
    weak var listener: RiskUnitListInteractListener?
    
    var listModel = MolueListItem<MLRiskUnitDetail>()
    
    required init(presenter: RiskUnitListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskUnitListPageInteractor: RiskUnitListRouterInteractable {
    
}

extension RiskUnitListPageInteractor: RiskUnitListPresentableListener {
    func queryRiskUnitPosition() {
        let size: Int = self.listModel.pagesize
        let request = MoluePerilService.queryPerilUnitPosition(page: 1, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLRiskUnitDetail>?) in
            do {
                try self.unwrap().handleQueryItem(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleRiskUnit(with: error, isMore: false)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleQueryItem(_ listModel: MolueListItem<MLRiskUnitDetail>?) {
        do {
            try self.listModel = listModel.unwrap()
        } catch { MolueLogger.network.message(error) }
        self.presenter?.endHeaderRefreshing()
        self.presenter?.reloadTableViewData()
    }
    
    private func handleRiskUnit(with error: Error, isMore: Bool) {
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
    
    func moreRiskUnitPosition() {
        do {
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.queryMoreRiskUnit(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func queryMoreRiskUnit(with page: Int, size: Int) {
        let request = MoluePerilService.queryPerilUnitPosition(page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLRiskUnitDetail>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleRiskUnit(with: error, isMore: true)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleMoreItems(_ listModel :MolueListItem<MLRiskUnitDetail>?) {
        do {
            try self.listModel.append(with: listModel)
        } catch { MolueLogger.UIModule.message(error)}
        
        let hasNext = listModel?.next.isSome() ?? false
        self.presenter?.endFooterRefreshing(with: hasNext)
        self.presenter?.reloadTableViewData()
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let results = self.listModel.results
            return try results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskUnit(with indexPath: IndexPath) -> MLRiskUnitDetail? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToRiskPointListController()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
