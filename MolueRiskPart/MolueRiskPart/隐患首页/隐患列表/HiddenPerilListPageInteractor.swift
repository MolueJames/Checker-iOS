//
//  HiddenPerilListPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol HiddenPerilListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol HiddenPerilListPagePresentable: MolueInteractorPresentable {
    var listener: HiddenPerilListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class HiddenPerilListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HiddenPerilListPagePresentable?
    
    var viewRouter: HiddenPerilListViewableRouting?
    
    weak var listener: HiddenPerilListInteractListener?
    
    required init(presenter: HiddenPerilListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension HiddenPerilListPageInteractor: HiddenPerilListRouterInteractable {
    
}

extension HiddenPerilListPageInteractor: HiddenPerilListPresentableListener {
    
}
