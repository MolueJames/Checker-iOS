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

protocol PolicyDetailPagePresentable: MolueInteractorPresentable {
    var listener: PolicyDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
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
    
}
