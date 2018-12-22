//
//  PolicyNoticeViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import MolueMediator
import MolueCommon
import ESPullToRefresh

protocol PolicyNoticePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryPolicyNoticeList()
    
    func morePolicyNoticeList()
    
    func numberOfRows(in section: Int) -> Int?
    
    func queryPolicyNotice(with indexPath: IndexPath) -> MLPolicyNoticeModel?
    
    func jumpToPolicyNoticeDetail(with indexPath: IndexPath)
}

final class PolicyNoticeViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PolicyNoticePresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: PolicyNoticeTableViewCell.self)
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
}

extension PolicyNoticeViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
    }
    
    func updateUserInterfaceElements() {
        self.title = "政策通知"
        self.tableView.es.addInfiniteScrolling(animator: self.footer) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.morePolicyNoticeList()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.addPullToRefresh(animator: self.header) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.queryPolicyNoticeList()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.refreshIdentifier = "Identifier"
        self.tableView.expiredTimeInterval = 20.0
        self.tableView.es.startPullToRefresh()
    }
}

extension PolicyNoticeViewController: PolicyNoticePagePresentable {
    func reloadTableViewData() {
        self.tableView.reloadData()
    }
    
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
}

extension PolicyNoticeViewController: PolicyNoticeViewControllable {
    
}

extension PolicyNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToPolicyNoticeDetail(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension PolicyNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PolicyNoticeTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryPolicyNotice(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
    
    
}
