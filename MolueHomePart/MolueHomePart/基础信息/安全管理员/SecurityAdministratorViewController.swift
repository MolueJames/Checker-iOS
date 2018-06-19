//
//  SecurityAdministratorViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueNavigator
import MolueCommon
import MolueUtilities
import MolueFoundation
import ViewAnimator
class SecurityAdministratorViewController: MLBaseViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewFooterView = AddAdministratorFooterView.createFromXib()
            tableViewFooterView.frame = CGRect(x: 0, y: 0, width:MLConfigure.screenWidth , height: 60)
            tableView.tableFooterView = tableViewFooterView
            tableView.register(xibWithCellClass: SecurityAdministratorTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var tableViewFooterView: AddAdministratorFooterView! {
        didSet {
            tableViewFooterView.addControlCommand.subscribe { _ in
                let router = MolueNavigatorRouter(.Home, path: HomePath.AddAdministrator.rawValue)
                MolueAppRouter.shared.pushRouter(router)
            }.disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "安全管理员"
        tableView.reloadData()
        let animations = [AnimationType.from(direction: .left, offset: 300.0)]
        UIView.animate(views: self.tableView.visibleCells, animations: animations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SecurityAdministratorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

extension SecurityAdministratorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SecurityAdministratorTableViewCell! = tableView.dequeueReusableCell(withClass: SecurityAdministratorTableViewCell.self)
        cell.reloadSubviewsWithModel()
        
        cell.phoneCommand?.subscribe(onNext: { (phone) in
            MLCommonFunction.ringUpPhone(phone)
        }).disposed(by: disposeBag)
        
        cell.detailCommand?.subscribe(onNext: { (_) in
            let router = MolueNavigatorRouter(.Home, path: HomePath.AddAdministrator.rawValue)
            MolueAppRouter.shared.pushRouter(router, parameters:["title": "编辑管理员"])
        }).disposed(by: disposeBag)
        return cell
    }
}
