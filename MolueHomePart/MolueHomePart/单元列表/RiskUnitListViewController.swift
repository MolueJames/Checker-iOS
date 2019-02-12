//
//  RiskUnitListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueMediator
import ESPullToRefresh
import MolueFoundation
import MolueUtilities

protocol RiskUnitListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(in section: Int) -> Int?
    
    func queryRiskUnit(with indexPath: IndexPath) -> MLRiskUnitDetail?
    
    func didSelectRow(at indexPath: IndexPath)
    
    func queryRiskUnitPosition()
    
    func moreRiskUnitPosition()
}

final class RiskUnitListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskUnitListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskUnitTableViewCell.self)
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

extension RiskUnitListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
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
    }
}

extension RiskUnitListViewController: RiskUnitListPagePresentable {
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

extension RiskUnitListViewController: RiskUnitListViewControllable {
    
}

extension RiskUnitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(in: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskUnitTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskUnit(with: indexPath)
            
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}

extension RiskUnitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.didSelectRow(at: indexPath)
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
}
