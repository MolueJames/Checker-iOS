//
//  DailyCheckTaskPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol DailyCheckTaskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol DailyCheckTaskPagePresentable: MolueInteractorPresentable {
    var listener: DailyCheckTaskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class DailyCheckTaskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DailyCheckTaskPagePresentable?
    
    var viewRouter: DailyCheckTaskViewableRouting?
    
    weak var listener: DailyCheckTaskInteractListener?
    
    required init(presenter: DailyCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskRouterInteractable {
    
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskPresentableListener {
    
}
