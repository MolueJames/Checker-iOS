//
//  HiddenPerilLevelPageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueFoundation
import MolueMediator
import MolueUtilities

protocol HiddenPerilLevelViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func popBackToPreviousController()
}

protocol HiddenPerilLevelPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: HiddenPerilLevelPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class HiddenPerilLevelPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: HiddenPerilLevelPagePresentable?
    
    var viewRouter: HiddenPerilLevelViewableRouting?
    
    weak var listener: HiddenPerilLevelInteractListener?
    
    private let levelList = PotentialRiskLevel.allCases
    
    required init(presenter: HiddenPerilLevelPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension HiddenPerilLevelPageInteractor: HiddenPerilLevelRouterInteractable {
    
}

extension HiddenPerilLevelPageInteractor: HiddenPerilLevelPresentableListener {
    func submitPotentialRiskLevel(with indexPath: IndexPath?) {
        if let indexPath = indexPath {
            self.handleSelectedPotentialRiskLevel(with: indexPath)
        } else {
            self.handleUnselectPotentialRiskLevel()
        }
    }
    
    func handleSelectedPotentialRiskLevel(with indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            let value = self.queryPotentialRiskLevel(with: indexPath)
            try listener.updatePotentialRiskLevel(with: value.unwrap())
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.popBackToPreviousController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func handleUnselectPotentialRiskLevel() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showWarningHUD(text: "请选择隐患级别")
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func queryPotentialRiskLevel(with indexPath: IndexPath) -> PotentialRiskLevel? {
        do {
            let item = self.levelList.item(at: indexPath.row)
            return try item.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows() -> Int {
        return self.levelList.count
    }
}
