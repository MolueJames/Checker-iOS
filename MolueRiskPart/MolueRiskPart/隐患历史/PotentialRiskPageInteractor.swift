//
//  PotentialRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator
import MolueCommon

protocol PotentialRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func createPerilListController()
}

protocol PotentialRiskPagePresentable: MolueInteractorPresentable {
    var listener: PotentialRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
}

final class PotentialRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: PotentialRiskPagePresentable?
    
    var viewRouter: PotentialRiskViewableRouting?
    
    weak var listener: PotentialRiskInteractListener?
    
    var selectedRisk: PotentialRiskModel?
    
    var valueList: [PotentialRiskModel] = AppRiskDocument.shared.riskList
    
    required init(presenter: PotentialRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension PotentialRiskPageInteractor: PotentialRiskRouterInteractable {
    
}

extension PotentialRiskPageInteractor: PotentialRiskPresentableListener {
    func queryPerilListController() {
        do {
            let router = try self.viewRouter.unwrap()
            router.createPerilListController()
        } catch { MolueLogger.UIModule.error(error) }
    }
}
