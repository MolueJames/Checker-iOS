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
    
    func pushToCheckDetailReport()
}

protocol CheckTaskDetailPagePresentable: MolueInteractorPresentable, MLControllerHUDProtocol {
    var listener: CheckTaskDetailPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class CheckTaskDetailPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: CheckTaskDetailPagePresentable?
    
    var viewRouter: CheckTaskDetailViewableRouting?
    
    weak var listener: CheckTaskDetailInteractListener?
    
    lazy var selectedCheckTask: MLDailyCheckTask? = {
        do {
            let listener = try self.listener.unwrap()
            let checkTask = try listener.currentCheckTask.unwrap()
            return checkTask
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

    }
    
    func updateEditRiskInfoModel(with item: PotentialRiskModel) {

    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailPresentableListener {
    func queryTaskSolution(with indexPath: IndexPath) -> MLRiskUnitSolution? {
        do {
            let currentTask = try self.selectedCheckTask.unwrap()
            let currentRisk = try currentTask.risk.unwrap()
            let solutions = try currentRisk.solutions.unwrap()
            return try solutions.item(at: indexPath.row).unwrap()
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
    
    func postCheckTaskDetailToServer() {
        
    }
    
    func numberOfRows(in section: Int) -> Int? {
        do {
            let currentTask = try self.selectedCheckTask.unwrap()
            let currentRisk = try currentTask.risk.unwrap()
            let solutions = try currentRisk.solutions.unwrap()
            return solutions.count
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}
