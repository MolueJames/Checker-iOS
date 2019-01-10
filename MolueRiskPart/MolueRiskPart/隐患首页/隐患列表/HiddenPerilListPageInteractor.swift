//
//  HiddenPerilListPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueFoundation
import MolueNetwork
import MolueUtilities
import MolueMediator

protocol HiddenPerilListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
    func pushToRiskClosedControlelr()
    func pushToRiskArrangeController()
    func pushToRiskRectifyController()
}

protocol HiddenPerilListPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: HiddenPerilListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class HiddenPerilListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HiddenPerilListPagePresentable?
    
    var viewRouter: HiddenPerilListViewableRouting?
    
    weak var listener: HiddenPerilListInteractListener?
    
    var listModel = MolueListItem<MLHiddenPerilItem>()
    
    required init(presenter: HiddenPerilListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension HiddenPerilListPageInteractor: HiddenPerilListRouterInteractable {
    
}

extension HiddenPerilListPageInteractor: HiddenPerilListPresentableListener {
    func queryHiddenPeril(with indexPath: IndexPath) -> MLHiddenPerilItem? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryHiddenPerilHistory() {
        let size: Int = self.listModel.pagesize
        let request = MoluePerilService.queryHiddenPerils(page: 1, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLHiddenPerilItem>?) in
            do {
                try self.unwrap().handleQueryItem(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handlePerilList(with: error, isMore: false)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleQueryItem(_ listModel: MolueListItem<MLHiddenPerilItem>?) {
        do {
            try self.listModel = listModel.unwrap()
        } catch { MolueLogger.network.message(error) }
        self.presenter?.endHeaderRefreshing()
        self.presenter?.reloadTableViewData()
    }
    
    private func handlePerilList(with error: Error, isMore: Bool) {
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
    
    func moreHiddenPerilHistory() {
        do {
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.queryMoreHiddenPerilHistory(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func queryMoreHiddenPerilHistory(with page: Int, size: Int) {
        let request = MoluePerilService.queryHiddenPerils(page: page, size: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLHiddenPerilItem>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handlePerilList(with: error, isMore: true)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleMoreItems(_ listModel :MolueListItem<MLHiddenPerilItem>?) {
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
            return results.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        do {
            let router = try self.viewRouter.unwrap()
            router.pushToRiskArrangeController()
        } catch { MolueLogger.UIModule.error(error) }
    }
}
