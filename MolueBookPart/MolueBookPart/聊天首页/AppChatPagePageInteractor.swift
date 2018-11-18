//
//  AppChatPagePageInteractor.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol AppChatPageViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol AppChatPagePagePresentable: MolueInteractorPresentable {
    var listener: AppChatPagePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class AppChatPagePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: AppChatPagePagePresentable?
    
    var viewRouter: AppChatPageViewableRouting?
    
    weak var listener: AppChatPageInteractListener?
    
    required init(presenter: AppChatPagePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension AppChatPagePageInteractor: AppChatPageRouterInteractable {
    
}

extension AppChatPagePageInteractor: AppChatPagePresentableListener {
    
}
