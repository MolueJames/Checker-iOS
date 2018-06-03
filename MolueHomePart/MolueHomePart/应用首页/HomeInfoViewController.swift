
//
//  HomeInforViewController.swift
//  MolueHomePart
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import RxSwift
import MolueCommon
import Permission
import ESPullToRefresh
import MolueNetwork
import MolueNavigator
import NVActivityIndicatorView
import MolueFoundation
class HomeInfoViewController: MLBaseViewController, NVActivityIndicatorViewable {
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.titleView = titleLabel
        self.initPublishSubjects()
    }
    
    func initPublishSubjects() {
        self.headerView.basicInfoCommand.subscribe(onNext: { _ in
            let router = MolueNavigatorRouter(.Home, path: HomeFilePath.EnterpriseInfo)
            MolueAppRouter.sharedInstance.pushRouter(router, needHideBottomBar: true)
        }).disposed(by: disposeBag)
        self.headerView.riskCheckCommand.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        self.headerView.notificationCommand.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        self.headerView.legislationCommand.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        self.headerView.educationCommand.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        self.headerView.dataRecordCommand.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func buttonClicked(button: Any?) {
        MoluePermission.camera { (status) in
            MolueLogger.success.message(status)
        }
    }
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
            tableview.separatorStyle = .none
            tableview.register(xibWithCellClass: HomeInfoTableViewCell.self)
            tableview.tableHeaderView = headerView
        }
    }
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "安监通"
        return label
    } ()
    
    lazy var headerView: HomeInfoTableHeaderView! = {
        let view: HomeInfoTableHeaderView = HomeInfoTableHeaderView.createFromXib()
        view.frame = CGRect.init(x: 0, y: 0, width: MLConfigure.screenWidth, height: 385)
        return view
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HomeInfoHeaderView.createFromXib()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension HomeInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeInfoTableViewCell.self)!
        return cell
    }
}

extension MLBaseViewController: MolueActivityDelegate {
    public func networkActivityStarted() {
        
    }
    
    public func networkActivitySuccess() {
        MolueLogger.network.message("success")
    }
    
    public func networkActivityFailure(error: Error) {
        print(error.localizedDescription)
    }
}
