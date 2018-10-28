//
//  ForgetPasswordPageInteractor.swift
//  MolueLoginPart
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import MolueMediator
import MolueUtilities
import MolueCommon
protocol ForgetPasswordViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func popBackFromForgetPassword()
}

protocol ForgetPasswordPagePresentable: MolueInteractorPresentable {
    var listener: ForgetPasswordPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
}

final class ForgetPasswordPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: ForgetPasswordPagePresentable?
    
    var viewRouter: ForgetPasswordViewableRouting?
    
    weak var listener: ForgetPasswordInteractListener?

    var tableViewAdapter: MLTableViewAdapter<ForgetPasswordTableViewCell, String>?
    
    var valueList: [String] = ["1","2","3"]
    
    required init(presenter: ForgetPasswordPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension ForgetPasswordPageInteractor: ForgetPasswordPresentableListener {
    func addToTableView(item: String) {
        self.tableViewAdapter?.append(with: item)
    }
    
    func bindingTableViewAdapter(with tableView: UITableView) {
        self.tableViewAdapter = MLTableViewAdapter<ForgetPasswordTableViewCell, String>(with: self.valueList)
        self.tableViewAdapter?.bindingTableView(tableView)
        self.tableViewAdapter?.heightForEachRow(64)
        self.tableViewAdapter?.cellForRowAtClosure({ (indexPath, cell, item) in
            cell.refreshSubviews(with: item)
        })
        self.tableViewAdapter?.didSelectRowAtClosure({ [weak self] (indexPath, item) in
            do {
                let strongSelf = try self.unwrap()
                let viewRouter = try strongSelf.viewRouter.unwrap()
                viewRouter.popBackFromForgetPassword()
            } catch {
                MolueLogger.UIModule.error(error)
            }
        })
    }
}

extension ForgetPasswordPageInteractor: ForgetPasswordRouterInteractable {
    
}
