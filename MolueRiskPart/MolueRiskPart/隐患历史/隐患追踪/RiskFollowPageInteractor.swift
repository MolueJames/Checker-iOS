//
//  RiskFollowPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskFollowViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskFollowPagePresentable: MolueInteractorPresentable {
    var listener: RiskFollowPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskFollowPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskFollowPagePresentable?
    
    var viewRouter: RiskFollowViewableRouting?
    
    weak var listener: RiskFollowInteractListener?
    
    required init(presenter: RiskFollowPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskFollowPageInteractor: RiskFollowRouterInteractable {
    
}

extension RiskFollowPageInteractor: RiskFollowPresentableListener {
    
}
