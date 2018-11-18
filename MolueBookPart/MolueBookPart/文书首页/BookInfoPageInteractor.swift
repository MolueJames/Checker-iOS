//
//  BookInfoPageInteractor.swift
//  MolueBookPart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol BookInfoViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol BookInfoPagePresentable: MolueInteractorPresentable {
    var listener: BookInfoPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class BookInfoPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: BookInfoPagePresentable?
    
    var viewRouter: BookInfoViewableRouting?
    
    weak var listener: BookInfoInteractListener?
    
    required init(presenter: BookInfoPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension BookInfoPageInteractor: BookInfoRouterInteractable {
    
}

extension BookInfoPageInteractor: BookInfoPresentableListener {
    
}
