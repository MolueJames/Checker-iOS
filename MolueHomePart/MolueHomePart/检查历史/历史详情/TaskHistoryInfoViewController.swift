//
//  TaskHistoryInfoViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-27.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities
import MolueFoundation

protocol TaskHistoryInfoPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var taskItem: DangerUnitRiskModel? {get}
    
    func jumpToHistoryDetailController(with item: RiskMeasureModel)
}

final class TaskHistoryInfoViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: TaskHistoryInfoPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: HistoryInfoTableViewCell.self)
            tableView.tableHeaderView = self.headerView
            self.headerView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
            }
            tableView.layoutIfNeeded()
            tableView.tableHeaderView = self.headerView
        }
    }
    
    lazy var headerView: DailyCheckTaskHeaderView = {
        let headerView: DailyCheckTaskHeaderView = DailyCheckTaskHeaderView.createFromXib()
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.taskItem.unwrap()
//            headerView.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return headerView
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension TaskHistoryInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.taskItem.unwrap()
            self.title = item.riskName
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension TaskHistoryInfoViewController: TaskHistoryInfoPagePresentable {
    
}

extension TaskHistoryInfoViewController: TaskHistoryInfoViewControllable {
    
}

extension TaskHistoryInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let taskItem = try listener.taskItem.unwrap()
            let measureList = try taskItem.riskMeasure.unwrap()
            return measureList.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HistoryInfoTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let taskItem = try listener.taskItem.unwrap()
            let measureList = try taskItem.riskMeasure.unwrap()
            let measureItem = try measureList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: measureItem)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}

extension TaskHistoryInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            let taskItem = try listener.taskItem.unwrap()
            let measureList = try taskItem.riskMeasure.unwrap()
            let measureItem = try measureList.item(at: indexPath.row).unwrap()
            listener.jumpToHistoryDetailController(with: measureItem)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: DailyCheckSectionHeaderView = DailyCheckSectionHeaderView.createFromXib()
        return headerView
    }
}
