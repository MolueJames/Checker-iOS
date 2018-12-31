//
//  FailureTaskListPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol FailureTaskListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol FailureTaskListPagePresentable: MolueInteractorPresentable {
    var listener: FailureTaskListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class FailureTaskListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: FailureTaskListPagePresentable?
    
    var viewRouter: FailureTaskListViewableRouting?
    
    weak var listener: FailureTaskListInteractListener?
    
    required init(presenter: FailureTaskListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension FailureTaskListPageInteractor: FailureTaskListRouterInteractable {
    
}

extension FailureTaskListPageInteractor: FailureTaskListPresentableListener {
    
}
