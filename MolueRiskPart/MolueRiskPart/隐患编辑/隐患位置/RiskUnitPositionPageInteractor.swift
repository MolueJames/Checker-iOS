//
//  RiskUnitPositionPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueFoundation
import MolueUtilities

protocol RiskUnitPositionViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskUnitPositionPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: RiskUnitPositionPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class RiskUnitPositionPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskUnitPositionPagePresentable?
    
    var viewRouter: RiskUnitPositionViewableRouting?
    
    weak var listener: RiskUnitPositionInteractListener?
    
    var listModel = MolueListItem<MLRiskUnitDetail>()
    
    required init(presenter: RiskUnitPositionPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskUnitPositionPageInteractor: RiskUnitPositionRouterInteractable {
    
}

extension RiskUnitPositionPageInteractor: RiskUnitPositionPresentableListener {

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
                try self.unwrap().handleClassification(with: error, isMore: false)
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
    
    private func handleClassification(with error: Error, isMore: Bool) {
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
            self.queryMoreRiskClassification(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func queryMoreRiskClassification(with page: Int, size: Int) {
        let request = MoluePerilService.queryPerilUnitPosition(page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLRiskUnitDetail>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleClassification(with: error, isMore: true)
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
            let results = try self.listModel.results.unwrap()
            let item = try results.item(at: section).unwrap()
            return try item.risks.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfSections() -> Int? {
        do {
            let results = self.listModel.results
            return try results.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskUnitDetail(with section: Int) -> MLRiskUnitDetail? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: section).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskPointDetail(with indexPath: IndexPath) -> MLRiskPointDetail? {
        do {
            let results = try self.listModel.results.unwrap()
            let item = try results.item(at: indexPath.section).unwrap()
            let children = try item.risks.unwrap()
            return try children.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func submitSelectedPointPosition(with indexPath: IndexPath?) {
        
    }
}
