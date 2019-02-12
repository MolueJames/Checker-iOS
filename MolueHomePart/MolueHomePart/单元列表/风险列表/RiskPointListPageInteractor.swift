//
//  RiskPointListPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskPointListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskPointListPagePresentable: MolueInteractorPresentable {
    var listener: RiskPointListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskPointListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskPointListPagePresentable?
    
    var viewRouter: RiskPointListViewableRouting?
    
    weak var listener: RiskPointListInteractListener?
    
    required init(presenter: RiskPointListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskPointListPageInteractor: RiskPointListRouterInteractable {
    
}

extension RiskPointListPageInteractor: RiskPointListPresentableListener {
    
}
