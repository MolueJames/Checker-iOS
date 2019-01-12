//
//  TaskCheckReportViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueCommon
import ESPullToRefresh
import MolueFoundation

protocol TaskCheckReportPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(in section: Int) -> Int?
    
    func numberOfHiddenPeril() -> Int?
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment?
    
    func queryRelatedHiddenPerils()
    
    func moreRelatedHiddenPerils()
    
    func queryHiddenPeril(with indexPath: IndexPath) -> MLHiddenPerilItem?
}

final class TaskCheckReportViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: TaskCheckReportPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.register(xibWithCellClass: TaskCheckReportTableViewCell.self)
            tableView.register(xibWithCellClass: TaskRiskReportTableViewCell.self)
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

extension TaskCheckReportViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        do {
            let listener = try self.listener.unwrap()
            listener.queryRelatedHiddenPerils()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func updateUserInterfaceElements() {
        self.title = "检查报告"
        self.tableView.es.addInfiniteScrolling(animator: self.footer) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.moreRelatedHiddenPerils()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.addPullToRefresh(animator: self.header) { [weak self] in
            do {
                let listener = try self.unwrap().listener.unwrap()
                listener.queryRelatedHiddenPerils()
            } catch {MolueLogger.UIModule.message(error)}
        }
        self.tableView.es.startPullToRefresh()
    }
}

extension TaskCheckReportViewController: TaskCheckReportPagePresentable {
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

extension TaskCheckReportViewController: TaskCheckReportViewControllable {
    
}

extension TaskCheckReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 142 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfHiddenPeril()
            if try section == 1 && count.unwrap() > 0 {
                return TaskRiskReportHeaderView.createFromXib()
            } else {
                return MolueLogger.UIModule.allowNil("")
            }
        } catch {
            return MolueLogger.UIModule.allowNil(error)
        }
    }
}

extension TaskCheckReportViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: TaskCheckReportTableViewCell.self)
            do {
                let listener = try self.listener.unwrap()
                let attachment = listener.queryTaskAttachment(with: indexPath)
                try cell.refreshSubviews(with: attachment.unwrap())
            } catch {
                MolueLogger.UIModule.message(error)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: TaskRiskReportTableViewCell.self)
            do {
                let listener = try self.listener.unwrap()
                let hiddenPeril = listener.queryHiddenPeril(with: indexPath)
                try cell.refreshSubviews(with: hiddenPeril.unwrap())
            } catch {
                MolueLogger.UIModule.message(error)
            }
            return cell
        }
    }
}
