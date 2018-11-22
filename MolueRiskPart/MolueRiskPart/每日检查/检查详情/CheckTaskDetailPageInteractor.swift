//
//  CheckTaskDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator

protocol CheckTaskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func presentExistedRiskDetailController()
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable {
    var listener: CheckTaskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CheckTaskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskDetailPagePresentable?
    
    var viewRouter: CheckTaskDetailViewableRouting?
    
    weak var listener: CheckTaskDetailInteractListener?
    
    required init(presenter: CheckTaskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailRouterInteractable {
    
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailPresentableListener {
    func displayExistedRiskDetailController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.presentExistedRiskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
