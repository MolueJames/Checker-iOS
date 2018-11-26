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
    
    required init(presenter: CheckTaskDetailPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailRouterInteractable {
    
}

extension CheckTaskDetailPageInteractor: CheckTaskDetailPresentableListener {
    var item: DangerUnitRiskModel? {
        get {
            let list = AppHomeDocument.shared.unitList.item(at: selectedIndex.section)
            return list?.unitRisks?.item(at: selectedIndex.row)
        }
        set {
            var list = AppHomeDocument.shared.unitList.item(at: selectedIndex.section)
            let row = self.selectedIndex.row
            do {
                list?.unitRisks?[row] = try newValue.unwrap()
                AppHomeDocument.shared.unitList[self.selectedIndex.section] = try list.unwrap()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        }
    }
    
    func jumpToTaskDetailController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToNoHiddenController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    

}
