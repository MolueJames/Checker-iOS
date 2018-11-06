//
//  RiskCheckTaskPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol RiskCheckTaskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskCheckTaskPagePresentable: MolueInteractorPresentable {
    var listener: RiskCheckTaskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskCheckTaskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskCheckTaskPagePresentable?
    
    var viewRouter: RiskCheckTaskViewableRouting?
    
    weak var listener: RiskCheckTaskInteractListener?
    
    required init(presenter: RiskCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskCheckTaskPageInteractor: RiskCheckTaskRouterInteractable {
    
}

extension RiskCheckTaskPageInteractor: RiskCheckTaskPresentableListener {
    
}
