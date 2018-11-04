//
//  PotentialRiskPageInteractor.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import MolueMediator
import MolueCommon

protocol PotentialRiskViewableRouting: class {
    // 定义一些页面跳转的方法, 比如Push, Presenter等.
    func pushToRiskDetailController()
}

protocol PotentialRiskPagePresentable: MolueInteractorPresentable {
    var listener: PotentialRiskPresentableListener? { get set }
    // 定义一些页面需要的方法, 比如刷新页面的显示内容等.
    
}

final class PotentialRiskPageInteractor: MoluePresenterInteractable {
    
    weak var presenter: PotentialRiskPagePresentable?
    
    var viewRouter: PotentialRiskViewableRouting?
    
    weak var listener: PotentialRiskInteractListener?
    
    var tableViewAdapter: MLTableViewAdapter<PotentialRiskTableViewCell, String>?
    
    var valueList: [String] = ["1","2","3","2","3","2","3","2","3","2","3","2","3","2","3"]
    
    required init(presenter: PotentialRiskPagePresentable) {
        self.presenter = presenter
        presenter.listener = self
    }
}

extension PotentialRiskPageInteractor: PotentialRiskRouterInteractable {
    
}

extension PotentialRiskPageInteractor: PotentialRiskPresentableListener {
    func bindingTableViewAdapter(with tableView: UITableView) {
        self.tableViewAdapter = MLTableViewAdapter<PotentialRiskTableViewCell, String>(with: self.valueList)
        self.tableViewAdapter?.bindingTableView(tableView)
        self.tableViewAdapter?.heightForEachRow(100)
        self.tableViewAdapter?.cellForRowAtClosure({ (indexPath, cell, item) in
            
        })
        self.tableViewAdapter?.didSelectRowAtClosure({ [weak self] (indexPath, item) in
            guard let self = self, let router = self.viewRouter else {return}
            router.pushToRiskDetailController()
        })
    }
}
