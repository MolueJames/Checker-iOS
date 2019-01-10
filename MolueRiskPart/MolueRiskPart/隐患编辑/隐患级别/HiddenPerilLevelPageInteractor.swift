//
//  HiddenPerilLevelPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator

protocol HiddenPerilLevelViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol HiddenPerilLevelPagePresentable: MolueInteractorPresentable {
    var listener: HiddenPerilLevelPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class HiddenPerilLevelPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HiddenPerilLevelPagePresentable?
    
    var viewRouter: HiddenPerilLevelViewableRouting?
    
    weak var listener: HiddenPerilLevelInteractListener?
    
    required init(presenter: HiddenPerilLevelPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension HiddenPerilLevelPageInteractor: HiddenPerilLevelRouterInteractable {
    
}

extension HiddenPerilLevelPageInteractor: HiddenPerilLevelPresentableListener {
    func numberOfRows() -> Int? {
        return 4
    }
    
    
}
