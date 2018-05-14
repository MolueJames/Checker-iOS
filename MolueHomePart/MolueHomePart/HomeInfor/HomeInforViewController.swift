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

class HomeInforViewController: MLBaseViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
            tableview.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
//            let header = MLRefreshHeaderAnimator.init(frame: CGRect.zero)
//            tableview.es.addPullToRefresh(animator: header) { [unowned self] in
//                self .loadData()
//            }
//            tableview.es.addInfiniteScrolling() { [weak self] in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                    self?.tableview.es.stopLoadingMore()
//                }
//            }
        }
    }
    
    func loadData()  {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "加载数据中...", type: NVActivityIndicatorType.lineScaleParty)
            AccountService.appVersion(device: "iOS", version: "1.0.0").start(success: { [weak self] (map) in
                MolueLogger.network.message(map)
                self?.tableview.es.stopPullToRefresh()
                NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
                }, failure: { [weak self] (error) in
                    MolueLogger.failure.message(error)
                    self?.tableview.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("加载数据中...")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安监通"
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false;
        self.edgesForExtendedLayout = .all;
        
        let view = HomeInfoTableHeaderView.createFromXib()
        print(view)
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

extension HomeInforViewController: UITableViewDelegate {
    
}

extension HomeInforViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.textLabel?.text = "indexPath.row = \(indexPath.row)"
        cell.imageView?.image = UIImage.init(named: "common_icon_refresh")
        return cell
    }
    
    
}
