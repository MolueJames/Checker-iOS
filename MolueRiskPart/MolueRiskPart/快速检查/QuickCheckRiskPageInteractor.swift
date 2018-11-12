//
//  QuickCheckRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator

protocol QuickCheckRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToTakePhotoController()
    func pushToScanQRCodeController()
}

protocol QuickCheckRiskPagePresentable: MolueInteractorPresentable {
    var listener: QuickCheckRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class QuickCheckRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: QuickCheckRiskPagePresentable?
    
    var viewRouter: QuickCheckRiskViewableRouting?
    
    weak var listener: QuickCheckRiskInteractListener?
    
    required init(presenter: QuickCheckRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskRouterInteractable {
    
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskPresentableListener {
    func jumpToScanQRCodeController() {
        
    }
    
    func jumpToTakePhotoController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToTakePhotoController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    
}
