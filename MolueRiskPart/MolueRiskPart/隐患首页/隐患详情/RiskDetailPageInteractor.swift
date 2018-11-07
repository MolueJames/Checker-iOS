//
//  RiskDetailPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskDetailPagePresentable: MolueInteractorPresentable {
    var listener: RiskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskDetailPagePresentable?
    
    var viewRouter: RiskDetailViewableRouting?
    
    weak var listener: RiskDetailInteractListener?
    
    required init(presenter: RiskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskDetailPageInteractor: RiskDetailRouterInteractable {
    
}

extension RiskDetailPageInteractor: RiskDetailPresentableListener {
    
}
