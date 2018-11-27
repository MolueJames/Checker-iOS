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
    func pushToNoHiddenController()
    func pushToEditRiskController()
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable {
    var listener: CheckTaskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CheckTaskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskDetailPagePresentable?
    
    var viewRouter: CheckTaskDetailViewableRouting?
    
    weak var listener: CheckTaskDetailInteractListener?

    lazy var selectedIndex: IndexPath = {
        let defaultIndex = IndexPath(row: 0, section: 0)
        return self.listener?.selectedIndex ?? defaultIndex
    }()
    
    lazy var item: DangerUnitRiskModel? = {
        do {
            let unitList = AppHomeDocument.shared.unitList
            let unitItem = try unitList.item(at: selectedIndex.section).unwrap()
            let riskList = try unitItem.unitRisks.unwrap()
            return try riskList.item(at: selectedIndex.row).unwrap()
        } catch {
            return MolueLogger.UIModule.returnNil(error)
        }
    }()
    
    var measureIndexPath: IndexPath?
    
    required init(presenter: CheckTaskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailRouterInteractable {
    func updateNoHiddenRiskModel(with item: TaskSuccessModel) {
        do {
            let currentItem = try self.item.unwrap()
            let row = try self.measureIndexPath.unwrap().row
            currentItem.riskMeasure?[row].taskModel = item
            self.item = currentItem
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateEditRiskInfoModel(with item: PotentialRiskModel) {
        do {
            let currentItem = try self.item.unwrap()
            let row = try self.measureIndexPath.unwrap().row
            currentItem.riskMeasure?[row].riskModel = item
            self.item = currentItem
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailPresentableListener {
    func jumpToTaskDetailController(with item: RiskMeasureModel, indexPath: IndexPath) {
        do {
            self.measureIndexPath = indexPath
            let viewRouter = try self.viewRouter.unwrap()
            if item.measureState {
                viewRouter.pushToNoHiddenController()
            } else {
                viewRouter.pushToEditRiskController()
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateCurrentItem() {
        do {
            let currentItem = try self.item.unwrap()
            var isSuccess: Bool = true
            for item in try currentItem.riskMeasure.unwrap() {
                if item.measureState == false {
                    isSuccess = false
                    break
                }
            }
            currentItem.riskStatus = isSuccess ? "已检查" : "有隐患"
            self.item = currentItem
            AppHomeDocument.shared.taskList.append(currentItem)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
//    var item: DangerUnitRiskModel? {
//        get {
//            do {
//                let unitList = AppHomeDocument.shared.unitList
//                let unitItem = try unitList.item(at: selectedIndex.section).unwrap()
//                let riskList = try unitItem.unitRisks.unwrap()
//                return try riskList.item(at: selectedIndex.row).unwrap()
//            } catch {
//                return MolueLogger.UIModule.returnNil(error)
//            }
//        }
//        set {
//            do {
//                let unitList = AppHomeDocument.shared.unitList
//                let unitItem = try unitList.item(at: selectedIndex.section).unwrap()
//                var unitRisk = try unitItem.unitRisks.unwrap()
//                try unitRisk[self.selectedIndex.row] = newValue.unwrap()
//            } catch {
//                MolueLogger.UIModule.error(error)
//            }
//        }
//    }
}
