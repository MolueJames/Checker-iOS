//
//  RiskPlanPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskPlanViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskPlanPagePresentable: MolueInteractorPresentable {
    var listener: RiskPlanPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskPlanPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskPlanPagePresentable?
    
    var viewRouter: RiskPlanViewableRouting?
    
    weak var listener: RiskPlanInteractListener?
    
    required init(presenter: RiskPlanPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskPlanPageInteractor: RiskPlanRouterInteractable {
    
}

extension RiskPlanPageInteractor: RiskPlanPresentableListener {
    
}
