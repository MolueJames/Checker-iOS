//
//  HomeInforViewController.swift
//  MolueHomePart
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueCommon
import Permission
import ESPullToRefresh
import MolueNetwork
import NVActivityIndicatorView
import MolueFoundation
class HomeInfoViewController: MLBaseViewController, NVActivityIndicatorViewable {
    let cellIdentifier = "HomeInfoCellIdentifier"
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
            tableview.register(HomeInfoTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            tableview.tableHeaderView = headerView
        }
    }
//            let header = MLRefreshHeaderAnimator.init(frame: CGRect.zero)
//            tableview.es.addPullToRefresh(animator: header) { [unowned self] in
//                self .loadData()
//            }
//            tableview.es.addInfiniteScrolling() { [weak self] in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    self?.tableview.es.stopLoadingMore()
//                }
//            }
//    func loadData()  {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            let size = CGSize(width: 30, height: 30)
//            self.startAnimating(size, message: "加载数据中...", type: NVActivityIndicatorType.lineScaleParty)
//            AccountService.appVersion(device: "iOS", version: "1.0.0").start(success: { [weak self] (map) in
//                MolueLogger.network.message(map)
//                self?.tableview.es.stopPullToRefresh()
//                NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
//                }, failure: { [weak self] (error) in
//                    MolueLogger.failure.message(error)
//                    self?.tableview.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
//                    NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
//            })
//        }
//    }
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "安监通"
        return label
    } ()
    
    lazy var headerView: HomeInfoTableHeaderView! = {
        let view: HomeInfoTableHeaderView! = HomeInfoTableHeaderView.createFromXib()
        view.frame = CGRect.init(x: 0, y: 0, width: MLConfigure.screenWidth, height: 405)
        view.backgroundColor = .gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.titleView = titleLabel
    }
    
    @IBAction func buttonClicked(button: Any?) {
        MoluePermission.camera { (status) in
            MolueLogger.success.message(status)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension HomeInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeInfoTableViewCell
        
        return cell
    }
    
    
}
