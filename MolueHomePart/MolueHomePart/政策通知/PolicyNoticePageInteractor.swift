//
//  PolicyNoticePageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueNetwork
import MolueUtilities

protocol PolicyNoticeViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol PolicyNoticePagePresentable: MolueInteractorPresentable {
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
            self.qureyMoreDailyPlanItem(with: page, size: size)
        } catch {
            self.presenter?.endFooterRefreshing(with: false)
        }
    }
    
    func qureyMoreDailyPlanItem(with page: Int, size: Int) {
        let request = MoluePolicyNoticeService.queryPolicyNoticeList(page: page, pagesize: size)
        request.handleSuccessResultToObjc { [weak self] (item: MolueListItem<MLPolicyNoticeModel>?) in
            do {
                try self.unwrap().handleMoreItems(item)
            } catch { MolueLogger.UIModule.message(error) }
        }
        MolueRequestManager().doRequestStart(with: request)
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
