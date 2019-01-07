//
//  RiskClosedPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskClosedViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskClosedPagePresentable: MolueInteractorPresentable {
    var listener: RiskClosedPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskClosedPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskClosedPagePresentable?
    
    var viewRouter: RiskClosedViewableRouting?
    
    weak var listener: RiskClosedInteractListener?
    
    required init(presenter: RiskClosedPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskClosedPageInteractor: RiskClosedRouterInteractable {
    
}

extension RiskClosedPageInteractor: RiskClosedPresentableListener {
    
}
