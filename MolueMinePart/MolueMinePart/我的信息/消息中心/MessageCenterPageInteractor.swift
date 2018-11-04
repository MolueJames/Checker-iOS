//
//  MessageCenterPageInteractor.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol MessageCenterViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol MessageCenterPagePresentable: MolueInteractorPresentable {
    var listener: MessageCenterPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class MessageCenterPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: MessageCenterPagePresentable?
    
    var viewRouter: MessageCenterViewableRouting?
    
    weak var listener: MessageCenterInteractListener?
    
    required init(presenter: MessageCenterPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension MessageCenterPageInteractor: MessageCenterRouterInteractable {
    
}

extension MessageCenterPageInteractor: MessageCenterPresentableListener {
    
}
