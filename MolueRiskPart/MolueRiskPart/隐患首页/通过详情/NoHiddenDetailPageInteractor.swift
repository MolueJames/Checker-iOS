//
//  NoHiddenDetailPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol NoHiddenDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol NoHiddenDetailPagePresentable: MolueInteractorPresentable {
    var listener: NoHiddenDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class NoHiddenDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: NoHiddenDetailPagePresentable?
    
    var viewRouter: NoHiddenDetailViewableRouting?
    
    weak var listener: NoHiddenDetailInteractListener?
    
    required init(presenter: NoHiddenDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension NoHiddenDetailPageInteractor: NoHiddenDetailRouterInteractable {
    
}

extension NoHiddenDetailPageInteractor: NoHiddenDetailPresentableListener {
    
}
