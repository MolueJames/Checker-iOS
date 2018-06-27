
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
import ESPullToRefresh
import MolueNetwork
import MolueNavigator
import MolueFoundation
import ViewAnimator
protocol HomeInfoDataProtocol: MLImpDataManagerProtocol {
    
}

class HomeInfoViewController: MLBaseViewController, MLDataManagerProtocol {
    
    var dataManager = HomeInfoDataManager()
    
    typealias DataManagerTarget = HomeInfoDataManager
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.titleView = titleLabel
        let animations = [AnimationType.from(direction: .top, offset: 80.0)]
        UIView.animate(views: self.tableView.visibleCells, animations: animations)
    }
    
    func initPublishSubjects() {
        self.headerView.basicInfoCommand.subscribe(onNext: { _ in
            let router = MolueNavigatorRouter(.Home, path: HomePath.EnterpriseInfo.rawValue)
            MolueAppRouter.shared.push(router, needHideBottomBar: true)
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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(xibWithCellClass: HomeInfoTableViewCell.self)
            headerView = HomeInfoTableHeaderView.createFromXib()
            tableView.tableHeaderView = headerView
        }
    }
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "安监通"
        return label
    } ()
    
    var headerView: HomeInfoTableHeaderView! {
        didSet {
            headerView.frame = CGRect.init(x: 0, y: 0, width: MLConfigure.screenWidth, height: 385)
            self.initPublishSubjects()
        }
    }

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
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeInfoTableViewCell.self)!
        return cell
    }
}


