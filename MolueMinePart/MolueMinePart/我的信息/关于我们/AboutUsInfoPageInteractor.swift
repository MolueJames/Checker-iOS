//
//  AboutUsInfoPageInteractor.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol AboutUsInfoViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol AboutUsInfoPagePresentable: MolueInteractorPresentable {
    var listener: AboutUsInfoPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class AboutUsInfoPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: AboutUsInfoPagePresentable?
    
    var viewRouter: AboutUsInfoViewableRouting?
    
    weak var listener: AboutUsInfoInteractListener?
    
    required init(presenter: AboutUsInfoPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension AboutUsInfoPageInteractor: AboutUsInfoRouterInteractable {
    
}

extension AboutUsInfoPageInteractor: AboutUsInfoPresentableListener {
    
}
