//
//  ExistedRiskDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/11.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator

protocol ExistedRiskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func doSubmitButtonClickedRouter()
    func doCancelButtonClickedRouter()
}

protocol ExistedRiskDetailPagePresentable: MolueInteractorPresentable {
    var listener: ExistedRiskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class ExistedRiskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: ExistedRiskDetailPagePresentable?
    
    var viewRouter: ExistedRiskDetailViewableRouting?
    
    weak var listener: ExistedRiskDetailInteractListener?
    
    required init(presenter: ExistedRiskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension ExistedRiskDetailPageInteractor: ExistedRiskDetailRouterInteractable {
    
}

extension ExistedRiskDetailPageInteractor: ExistedRiskDetailPresentableListener {
    func doSubmitButtonClickedAction() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.doSubmitButtonClickedRouter()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func doCancelButtonClickedAction() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.doCancelButtonClickedRouter()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    
}
