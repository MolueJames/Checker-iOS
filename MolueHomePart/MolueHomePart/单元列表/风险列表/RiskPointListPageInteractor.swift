//
//  RiskPointListPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueUtilities
import MolueMediator

protocol RiskPointListViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
}

protocol RiskPointListPagePresentable: MolueInteractorPresentable {
    var listener: RiskPointListPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class RiskPointListPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: RiskPointListPagePresentable?
    
    var viewRouter: RiskPointListViewableRouting?
    
    weak var listener: RiskPointListInteractListener?
    
    lazy var riskUnitDetail: MLRiskUnitDetail? = {
        do {
            let listener = try self.listener.unwrap()
            let riskUnitDetail = listener.riskUnitDetail
            return try riskUnitDetail.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    lazy var riskPointList: [MLRiskPointDetail]? = {
        do {
            let riskUnit = try self.riskUnitDetail.unwrap()
            return try riskUnit.risks.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }()
    
    required init(presenter: RiskPointListPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension RiskPointListPageInteractor: RiskPointListRouterInteractable {
    
}

extension RiskPointListPageInteractor: RiskPointListPresentableListener {
    func queryRiskUnitName() -> String? {
        do {
            let riskUnit = try self.riskUnitDetail.unwrap()
            return try riskUnit.unitName.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            return try self.riskPointList.unwrap().count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func queryRiskPoint(at indexPath: IndexPath) -> MLRiskPointDetail? {
        do {
            let pointList = try self.riskPointList.unwrap()
            let riskPoint = pointList.item(at: indexPath.row)
            return try riskPoint.unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
