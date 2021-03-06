//
//  CheckTaskListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities
import MolueFoundation
import MolueNetwork
import MolueCommon
import ESPullToRefresh

protocol CheckTaskListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryDailyCheckDangerUnit()
    
    func moreDailyCheckDangerUnit()
    
    func numberOfSections() -> Int?
    
    func numberOfRows(in section: Int) -> Int?
    
    func queryPlanItem(with section: Int) -> MLDailyCheckPlan?
    
    func queryTaskItem(with indexPath: IndexPath) -> MLDailyCheckTask?
    
    func jumpToCheckTaskDetail(with indexPath: IndexPath)
    
    func reloadCheckTask(with task: MLDailyCheckTask)
}

final class CheckTaskListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskTaskListTableViewCell.self)
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
        NotificationCenter.default.removeObserver(self)
    }
}

extension CheckTaskListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        let name = MolueNotification.check_task_finish.toName()
        let selector: Selector = #selector(checkTaskFinished)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    @IBAction func checkTaskFinished(_ notification: NSNotification) {
        do {
            let listener = try self.listener.unwrap()
            let task = notification.object as? MLDailyCheckTask
            try listener.reloadCheckTask(with: task.unwrap())
        } catch {
            MolueLogger.UIModule.message(error)
        }
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func updateUserInterfaceElements() {
        self.title = "定期检查"
        self.tableView.es.addInfiniteScrolling(animator: self.footer) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.moreDailyCheckDangerUnit()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.addPullToRefresh(animator: self.header) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.queryDailyCheckDangerUnit()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.startPullToRefresh()
    }
}

extension CheckTaskListViewController: CheckTaskListPagePresentable {
    func reloadTableViewCell(with indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
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
    
    func reloadTableViewData() {
        self.tableView.reloadData()
    }
    
    func popBackWhenTaskChecked() {
        self.tableView.reloadData()
        self.navigationController?.popToViewController(self, animated: true)
    }
}

extension CheckTaskListViewController: CheckTaskListViewControllable {
    
}

extension CheckTaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: CheckTaskSectionHeaderView = CheckTaskSectionHeaderView.createFromXib()
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryPlanItem(with: section)
            try headerView.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToCheckTaskDetail(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension CheckTaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfSections().unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskTaskListTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryTaskItem(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}
