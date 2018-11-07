//
//  RiskRectifyPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskRectifyViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskRectifyPagePresentable: MolueInteractorPresentable {
    var listener: RiskRectifyPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskRectifyPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskRectifyPagePresentable?
    
    var viewRouter: RiskRectifyViewableRouting?
    
    weak var listener: RiskRectifyInteractListener?
    
    required init(presenter: RiskRectifyPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskRectifyPageInteractor: RiskRectifyRouterInteractable {
    
}

extension RiskRectifyPageInteractor: RiskRectifyPresentableListener {
    
}
