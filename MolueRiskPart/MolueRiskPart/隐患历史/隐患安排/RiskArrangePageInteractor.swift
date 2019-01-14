//
//  RiskArrangePageInteractor.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskArrangeViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskArrangePagePresentable: MolueInteractorPresentable {
    var listener: RiskArrangePresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskArrangePageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskArrangePagePresentable?
    
    var viewRouter: RiskArrangeViewableRouting?
    
    weak var listener: RiskArrangeInteractListener?
    
    lazy var hiddenPeril: MLHiddenPerilItem? = {
        do {
            let listener = try self.listener.unwrap()
            return try listener.hiddenPeril.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: RiskArrangePagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskArrangePageInteractor: RiskArrangeRouterInteractable {
    
}

extension RiskArrangePageInteractor: RiskArrangePresentableListener {
    func queryHiddenPeril() -> MLHiddenPerilItem? {
        return self.hiddenPeril
    }
    
}
