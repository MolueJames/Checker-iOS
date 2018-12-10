//
//  CommonWebPageInteractor.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/12/10.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol CommonWebViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol CommonWebPagePresentable: MolueInteractorPresentable {
    var listener: CommonWebPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CommonWebPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CommonWebPagePresentable?
    
    var viewRouter: CommonWebViewableRouting?
    
    weak var listener: CommonWebInteractListener?
    
    required init(presenter: CommonWebPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CommonWebPageInteractor: CommonWebRouterInteractable {
    
}

extension CommonWebPageInteractor: CommonWebPresentableListener {
    
}
