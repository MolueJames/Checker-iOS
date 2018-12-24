//
//  TaskCheckReportPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator

protocol TaskCheckReportViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol TaskCheckReportPagePresentable: MolueInteractorPresentable {
    var listener: TaskCheckReportPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class TaskCheckReportPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: TaskCheckReportPagePresentable?
    
    var viewRouter: TaskCheckReportViewableRouting?
    
    weak var listener: TaskCheckReportInteractListener?
    
    required init(presenter: TaskCheckReportPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension TaskCheckReportPageInteractor: TaskCheckReportRouterInteractable {
    
}

extension TaskCheckReportPageInteractor: TaskCheckReportPresentableListener {
    
}
