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

protocol SecurityAdminiDataProtocol: MLImpDataManagerProtocol {
    
}

protocol SecurityAdminiNavigatorProtocol: MLAppImpNavigatorProtocol {
    func pushToIncreaseAdmini()
}

class SecurityAdminiViewController: MLBaseViewController, MLAppNavigatorProtocol, MLDataManagerProtocol {
    typealias DataManagerTarget = SecurityAdminiDataManager
    typealias NavigatorTarget = SecurityAdminiNavigator
    
    internal var dataManager = SecurityAdminiDataManager()
    internal var navigator = SecurityAdminiNavigator()
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewFooterView = IncreaseAdminiFooterView.createFromXib()
            tableViewFooterView.frame = CGRect(x: 0, y: 0, width:MLConfigure.screenWidth , height: 60)
            tableView.tableFooterView = tableViewFooterView
            tableView.register(xibWithCellClass: SecurityAdminiTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var tableViewFooterView: IncreaseAdminiFooterView! {
        didSet {
            tableViewFooterView.addControlCommand.subscribe(onNext: { [unowned self] (_) in
                self.navigator.pushToIncreaseAdmini()
            }).disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "安全管理员"
        tableView.reloadData()
        let animations = [AnimationType.from(direction: .top, offset: 115)]
        UIView.animate(views: self.tableView.visibleCells, animations: animations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SecurityAdminiViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}

extension SecurityAdminiViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SecurityAdminiTableViewCell! = tableView.dequeueReusableCell(withClass: SecurityAdminiTableViewCell.self)
        cell.reloadSubviewsWithModel()
        
        cell.phoneCommand?.subscribe(onNext: { (phone) in
            MLCommonFunction.ringUpPhone(phone)
        }).disposed(by: disposeBag)
        
        cell.detailCommand?.subscribe(onNext: { [unowned self] (_) in
            self.navigator.pushToIncreaseAdmini()
        }).disposed(by: disposeBag)
        return cell
    }
}
