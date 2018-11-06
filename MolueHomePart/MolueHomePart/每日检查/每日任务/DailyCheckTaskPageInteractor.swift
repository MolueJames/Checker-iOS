//
//  DailyCheckTaskPageInteractor.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueCommon

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
    
    var tableViewAdapter: MLTableViewAdapter<DailyCheckTaskTableViewCell, String>?
    
    var valueList: [String] = ["1", "2", "3"]
    
    required init(presenter: DailyCheckTaskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskRouterInteractable {
    
}

extension DailyCheckTaskPageInteractor: DailyCheckTaskPresentableListener {
    func bindingTableViewAdapter(with tableView: UITableView) {
        self.tableViewAdapter = MLTableViewAdapter<DailyCheckTaskTableViewCell, String>(with: self.valueList)
        self.tableViewAdapter?.bindingTableView(tableView)
        self.tableViewAdapter?.heightForEachRow(50)
        self.tableViewAdapter?.cellForRowAtClosure({ (indexPath, cell, item) in
            
        })
        self.tableViewAdapter?.didSelectRowAtClosure({ [weak self] (indexPath, item) in
            guard let self = self, let viewRouter = self.viewRouter else {return}
            viewRouter.pushToCheckTaskDetailController()
        })
    }
}
