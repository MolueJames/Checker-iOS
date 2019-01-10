//
//  RiskClassificationsViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueCommon
import MolueFoundation
import MolueUtilities
import ESPullToRefresh

protocol RiskClassificationsPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryRiskClassification()
    
    func moreRiskClassification()
    
    func numberOfRows(in section: Int) -> Int?
    
    func numberOfSections() -> Int?
    
    func queryRiskClassification(with indexPath: IndexPath) -> MLRiskClassification?
    
    func queryRiskClassification(with section: Int) -> MLRiskClassification?
    
    func submitSelectedClassification(with indexPath: IndexPath?)
}

final class RiskClassificationsViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskClassificationsPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskDetailSelectTableViewCell.self)
        }
    }
    
    lazy var header: MLRefreshHeaderAnimator = {
        let header = MLRefreshHeaderAnimator(frame: CGRect.zero)
        return header
    }()
    
    lazy var footer: ESRefreshFooterAnimator = {
        let footer = ESRefreshFooterAnimator(frame: CGRect.zero)
        return footer
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        self.tableView.es.removeRefreshFooter()
        self.tableView.es.removeRefreshHeader()
    }
}

extension RiskClassificationsViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患分类"
        self.tableView.es.addInfiniteScrolling(animator: self.footer) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.moreRiskClassification()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.addPullToRefresh(animator: self.header) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.queryRiskClassification()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.startPullToRefresh()
        
        let rightItem = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(rightItemClicked))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            let indexPath = self.tableView.indexPathForSelectedRow
            listener.submitSelectedClassification(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension RiskClassificationsViewController: RiskClassificationsPagePresentable {
    func endHeaderRefreshing() {
        self.tableView.es.stopPullToRefresh()
    }
    
    func endFooterRefreshing(with hasMore: Bool) {
        if hasMore {
            self.tableView.es.stopLoadingMore()
        } else {
            self.tableView.es.noticeNoMoreData()
        }
    }
    
    func reloadTableViewData() {
        self.tableView.reloadData()
    }
}

extension RiskClassificationsViewController: RiskClassificationsViewControllable {
    
}

extension RiskClassificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskDetailSelectTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskClassification(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfSections().unwrap()
        } catch { return 0 }
    }
}

extension RiskClassificationsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: RiskDetailSectionHeaderView = RiskDetailSectionHeaderView.createFromXib()
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskClassification(with: section)
            try view.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
}
