//
//  RiskUnitPositionViewController.swift
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

protocol RiskUnitPositionPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryRiskUnitPosition()
    
    func moreRiskUnitPosition()
    
    func numberOfRows(in section: Int) -> Int?
    
    func numberOfSections() -> Int?
    
    func queryRiskUnitDetail(with section: Int) -> MLRiskUnitDetail?
    
    func queryRiskPointDetail(with indexPath: IndexPath) -> MLRiskPointDetail?
    
    func submitSelectedPointPosition(with indexPath: IndexPath?)
}

final class RiskUnitPositionViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskUnitPositionPresentableListener?
    
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

extension RiskUnitPositionViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患位置"
        self.tableView.es.addInfiniteScrolling(animator: self.footer) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.moreRiskUnitPosition()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.addPullToRefresh(animator: self.header) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.queryRiskUnitPosition()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.startPullToRefresh()
        
        let rightItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(rightItemClicked))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            let indexPath = self.tableView.indexPathForSelectedRow
            listener.submitSelectedPointPosition(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension RiskUnitPositionViewController: RiskUnitPositionPagePresentable {
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

extension RiskUnitPositionViewController: RiskUnitPositionViewControllable {
    
}

extension RiskUnitPositionViewController: UITableViewDataSource {
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
            let item = listener.queryRiskPointDetail(with: indexPath)
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

extension RiskUnitPositionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskUnitDetail(with: section)
            return try item.unwrap().unitName.unwrap()
        } catch { return "暂无数据" }
    }
}

