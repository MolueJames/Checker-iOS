//
//  RiskClassificationsPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueFoundation
import MolueUtilities

protocol RiskClassificationsViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskClassificationsPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: RiskClassificationsPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.

    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class RiskClassificationsPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskClassificationsPagePresentable?
    
    var viewRouter: RiskClassificationsViewableRouting?
    
    weak var listener: RiskClassificationsInteractListener?
    
    var listModel = MolueListItem<MLRiskClassification>()
    
    required init(presenter: RiskClassificationsPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskClassificationsPageInteractor: RiskClassificationsRouterInteractable {
    
}

extension RiskClassificationsPageInteractor: RiskClassificationsPresentableListener {
    func queryRiskClassification(with section: Int) -> MLRiskClassification? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: section).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func submitSelectedClassification(with indexPath: IndexPath?) {
        
    }

    func queryRiskClassification() {
        let size: Int = self.listModel.pagesize
        let request = MoluePerilService.queryRiskClassification(page: 1, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLRiskClassification>?) in
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
    
    private func handleQueryItem(_ listModel: MolueListItem<MLRiskClassification>?) {
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
    
    func moreRiskClassification() {
        do {
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.queryMoreRiskClassification(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func queryMoreRiskClassification(with page: Int, size: Int) {
        let request = MoluePerilService.queryRiskClassification(page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLRiskClassification>?) in
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
    
    private func handleMoreItems(_ listModel :MolueListItem<MLRiskClassification>?) {
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
            let children = try item.children.unwrap()
            return children.count
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
    
    func queryRiskClassification(with indexPath: IndexPath) -> MLRiskClassification? {
        do {
            let results = try self.listModel.results.unwrap()
            let item = try results.item(at: indexPath.section).unwrap()
            let children = try item.children.unwrap()
            return try children.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
