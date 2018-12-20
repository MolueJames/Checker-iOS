//
//  PolicyNoticePageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueFoundation
import MolueUtilities

protocol PolicyNoticeViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToPolicyDetailController()
}

protocol PolicyNoticePagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: PolicyNoticePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
    func reloadTableViewData()
    
    func endHeaderRefreshing()
    
    func endFooterRefreshing(with hasMore: Bool)
}

final class PolicyNoticePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: PolicyNoticePagePresentable?
    
    var viewRouter: PolicyNoticeViewableRouting?
    
    weak var listener: PolicyNoticeInteractListener?
    
    var listModel = MolueListItem<MLPolicyNoticeModel>()
    
    var selectedPolicyNotice: MLPolicyNoticeModel?
    
    required init(presenter: PolicyNoticePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension PolicyNoticePageInteractor: PolicyNoticeRouterInteractable {
    
}

extension PolicyNoticePageInteractor: PolicyNoticePresentableListener {
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let results = try self.listModel.results.unwrap()
            return results.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryPolicyNotice(with indexPath: IndexPath) -> MLPolicyNoticeModel? {
        do {
            let results = try self.listModel.results.unwrap()
            return try results.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func jumpToPolicyNoticeDetail(with indexPath: IndexPath) {
        let policyNotice = self.queryPolicyNotice(with: indexPath)
        self.selectedPolicyNotice = policyNotice
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToPolicyDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryPolicyNoticeList() {
        let pagesize: Int = self.listModel.pagesize
        let page: Int = self.listModel.next ?? 1
        let request = MoluePolicyNoticeService.queryPolicyNoticeList(page: page, pagesize: pagesize)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLPolicyNoticeModel>?) in
            do {
                try self.unwrap().handleQueryItem(item)
            } catch {MolueLogger.UIModule.message(error)}
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleQueryNotice(with: error, isMore: true)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    private func handleQueryItem(_ listModel: MolueListItem<MLPolicyNoticeModel>?) {
        do {
            try self.listModel = listModel.unwrap()
        } catch {MolueLogger.network.message(error)}
        self.presenter?.endHeaderRefreshing()
        self.presenter?.reloadTableViewData()
    }
    
    func morePolicyNoticeList() {
        do {
            let page: Int = try self.listModel.next.unwrap()
            let size: Int = self.listModel.pagesize
            self.qureyMorePolicyNotice(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func qureyMorePolicyNotice(with page: Int, size: Int) {
        let request = MoluePolicyNoticeService.queryPolicyNoticeList(page: page, pagesize: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLPolicyNoticeModel>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        request.handleFailureResponse { [weak self] (error) in
            do {
                try self.unwrap().handleQueryNotice(with: error, isMore: false)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
    }
    
    func handleQueryNotice(with error: Error, isMore: Bool) {
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
    
    private func handleMoreItems(_ listModel :MolueListItem<MLPolicyNoticeModel>?) {
        do {
            try self.listModel.appendMoreResults(with: listModel)
        } catch { MolueLogger.UIModule.message(error)}
        
        let hasNext = listModel?.next.isSome() ?? false
        self.presenter?.endFooterRefreshing(with: hasNext)
        self.presenter?.reloadTableViewData()
    }
}
