//
//  BookDetailsPageInteractor.swift
//  MolueBookPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol BookDetailsViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol BookDetailsPagePresentable: MolueInteractorPresentable {
    var listener: BookDetailsPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class BookDetailsPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: BookDetailsPagePresentable?
    
    var viewRouter: BookDetailsViewableRouting?
    
    weak var listener: BookDetailsInteractListener?
    
    required init(presenter: BookDetailsPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension BookDetailsPageInteractor: BookDetailsRouterInteractable {
    
}

extension BookDetailsPageInteractor: BookDetailsPresentableListener {
    
}
