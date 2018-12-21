//
//  CheckTaskDetailPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//
import MolueUtilities
import MolueMediator
import MolueFoundation

protocol CheckTaskDetailViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToNoHiddenController()
    func pushToEditRiskController()
    func popToPreviewController()
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: CheckTaskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CheckTaskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskDetailPagePresentable?
    
    var viewRouter: CheckTaskDetailViewableRouting?
    
    weak var listener: CheckTaskDetailInteractListener?
    
    var measureIndexPath: IndexPath?
    
    required init(presenter: CheckTaskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailRouterInteractable {
    func updateNoHiddenRiskModel(with item: TaskSuccessModel) {

    }
    
    func updateEditRiskInfoModel(with item: PotentialRiskModel) {

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
        func checkMeasureItemState(list: [RiskMeasureModel], riskItem: DangerUnitRiskModel) {
            for item in list {
                if item.measureState == false {
                    riskItem.riskStatus = "有隐患"
                    break
                }
                riskItem.riskStatus = "已检查"
            }
        }
        func doAppendRiskItem(to item: DangerUnitRiskModel) {
            do {
                let row = try self.measureIndexPath.unwrap().row
                let risk = item.riskMeasure?[row].riskModel
                try AppRiskDocument.shared.riskList.append(risk.unwrap())
            } catch {
                MolueLogger.UIModule.message(error)
            }
        }
    }
    
    func doPopPreviewController() {
        do {
            let presenter = try self.presenter.unwrap()
            presenter.showSuccessHUD(text: "任务提交成功")
            Async.main(after: 1.5) { [weak self] in
                do {
                    let strongSelf = try self.unwrap()
                    let listener = try strongSelf.listener.unwrap()
//                    listener.doPopToPreviewController()
                } catch {
                    MolueLogger.UIModule.message(error)
                }
            }
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
