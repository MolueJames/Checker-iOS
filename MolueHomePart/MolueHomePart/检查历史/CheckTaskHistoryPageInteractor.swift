//
//  CheckTaskHistoryPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol CheckTaskHistoryViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol CheckTaskHistoryPagePresentable: MolueInteractorPresentable {
    var listener: CheckTaskHistoryPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CheckTaskHistoryPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskHistoryPagePresentable?
    
    var viewRouter: CheckTaskHistoryViewableRouting?
    
    weak var listener: CheckTaskHistoryInteractListener?
    
    required init(presenter: CheckTaskHistoryPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskHistoryPageInteractor: CheckTaskHistoryRouterInteractable {
    
}

extension CheckTaskHistoryPageInteractor: CheckTaskHistoryPresentableListener {
    
}
