//
//  RiskAcceptPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskAcceptViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskAcceptPagePresentable: MolueInteractorPresentable {
    var listener: RiskAcceptPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskAcceptPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskAcceptPagePresentable?
    
    var viewRouter: RiskAcceptViewableRouting?
    
    weak var listener: RiskAcceptInteractListener?
    
    required init(presenter: RiskAcceptPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskAcceptPageInteractor: RiskAcceptRouterInteractable {
    
}

extension RiskAcceptPageInteractor: RiskAcceptPresentableListener {
    
}
