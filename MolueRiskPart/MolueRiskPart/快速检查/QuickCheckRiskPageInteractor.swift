//
//  QuickCheckRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/12.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator
import MolueCommon
import Gallery

protocol QuickCheckRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToScanQRCodeController()
    func pushToEditRiskController()
    func pushToDailyCheckController()
}

protocol QuickCheckRiskPagePresentable: MolueInteractorPresentable {
    var listener: QuickCheckRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class QuickCheckRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: QuickCheckRiskPagePresentable?
    
    var viewRouter: QuickCheckRiskViewableRouting?
    
    weak var listener: QuickCheckRiskInteractListener?
    
    var selectedItem: DangerUnitRiskModel?
    
    required init(presenter: QuickCheckRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskRouterInteractable {
    
    func didScannedQRCode(with QRCode: String, controller: SWQRCodeViewController) {
        do {
            let navigator = try controller.navigationController.unwrap()
            navigator.popViewController(animated: false)
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToDailyCheckController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension QuickCheckRiskPageInteractor: QuickCheckRiskPresentableListener {
    func jumpToEditRiskController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToEditRiskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func jumpToScanQRCodeController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToScanQRCodeController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
