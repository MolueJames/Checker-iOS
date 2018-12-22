//
//  PolicyDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueNetwork

protocol PolicyDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol PolicyDetailPagePresentable: MolueInteractorPresentable, MolueActivityDelegate {
    var listener: PolicyDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    func refreshSubviews(with notice: MLPolicyNoticeModel)
}

final class PolicyDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: PolicyDetailPagePresentable?
    
    var viewRouter: PolicyDetailViewableRouting?
    
    weak var listener: PolicyDetailInteractListener?
    
    lazy var notificationItem: MoluePolicyNotification? = {
        do {
            let listener = try self.listener.unwrap()
            let notice = try listener.selectedPolicyNotice.unwrap()
            return try notice.notification.unwrap()
        } catch {
            return MolueLogger.database.returnNil(error)
        }
    }()
    
    lazy var selectedNotice: MLPolicyNoticeModel? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.selectedPolicyNotice.unwrap()
        } catch {
            return MolueLogger.database.returnNil(error)
        }
    }()
    
    required init(presenter: PolicyDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension PolicyDetailPageInteractor: PolicyDetailRouterInteractable {
    
}

extension PolicyDetailPageInteractor: PolicyDetailPresentableListener {
    func signCurrentNotification() {
        if self.selectedNotice?.signed == true {return}
        do {
            let notice = try self.selectedNotice.unwrap()
            let noticeId = try notice.noticeId.unwrap()
            self.doSingCurrentNotice(with: noticeId)
        } catch {
            MolueLogger.network.message(error)
        }
    }
    
    func readCurrentNotification() {
        if self.selectedNotice?.readed == true {return}
        Async.main(after: 2) { [weak self] in
            do {
                let strongSelf = try self.unwrap()
                let notice = try strongSelf.selectedNotice.unwrap()
                let noticeId = try notice.noticeId.unwrap()
                strongSelf.doReadCurrentNotice(with: noticeId)
            } catch {
                MolueLogger.network.message(error)
            }
        }
    }
    
    func doSingCurrentNotice(with noticeId: Int) {
        let dataRequest = MolueNoticeService.signPolicyNotification(with: noticeId)
        dataRequest.handleSuccessResponse { (result) in
            MolueLogger.network.message(result)
        }
        dataRequest.handleFailureResponse { (error) in
            MolueLogger.network.message(error)
        }
        let requestManager = MolueRequestManager(delegate: self.presenter)
        requestManager.doRequestStart(with: dataRequest)
    }
    
    func doReadCurrentNotice(with noticeId: Int) {
        let dataRequest = MolueNoticeService.readPolicyNotification(with: noticeId)
        dataRequest.handleSuccessResultToObjc { [weak self] (item: MLPolicyNoticeModel?) in
            do {
                let strongSelf = try self.unwrap()
                let presenter = try strongSelf.presenter.unwrap()
                try presenter.refreshSubviews(with: item.unwrap())
            } catch {
                MolueLogger.network.message(error)
            }
        }
        MolueRequestManager().doRequestStart(with: dataRequest)
    }
}
