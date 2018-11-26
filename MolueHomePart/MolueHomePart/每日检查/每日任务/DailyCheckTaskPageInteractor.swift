//
//  DailyCheckTaskPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueCommon
import MolueUtilities

protocol DailyCheckTaskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToCheckTaskDetailController()
}

protocol DailyCheckTaskPagePresentable: MolueInteractorPresentable {
    var listener: DailyCheckTaskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
}

final class DailyCheckTaskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: DailyCheckTaskPagePresentable?
    
    var viewRouter: DailyCheckTaskViewableRouting?
    
    weak var listener: DailyCheckTaskInteractListener?
    
    var valueList: [String] = ["1", "2", "3"]

    lazy var selectedIndex: IndexPath = {
        let defaultIndex = IndexPath(row: 0, section: 0)
        return self.listener?.selectedIndex ?? defaultIndex
    }()
    
    required init(presenter: DailyCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskRouterInteractable {
    
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskPresentableListener {
    var item: DangerUnitRiskModel? {
        let list = AppHomeDocument.shared.unitList.item(at: selectedIndex.section)
        return list?.unitRisks?.item(at: selectedIndex.row)
    }
    
    func jumpToCheckTaskDetailController() {
        do {
            let viewRouter = try self.viewRouter.unwrap()
            viewRouter.pushToCheckTaskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
