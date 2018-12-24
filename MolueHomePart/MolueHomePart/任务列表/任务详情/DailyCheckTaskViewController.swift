//
//  DailyCheckTaskViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol DailyCheckTaskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(with sections: Int) -> Int?
    
    func querySolutionItem(with indexPath: IndexPath) -> MLRiskUnitSolution?
    
    func queryDailyCheckTask()
    
    func jumpToCheckTaskDetailController()
}

final class DailyCheckTaskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DailyCheckTaskPresentableListener?
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.masksToBounds = false
            let color = MLCommonColor.titleLabel.cgColor
            submitButton.layer.borderColor = color
            submitButton.layer.shadowOffset = CGSize(width: 0, height: -1)
            submitButton.layer.shadowRadius = 1;
            submitButton.layer.shadowOpacity = 0.2
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: DailyCheckTaskTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableHeaderView = self.headerView
            tableView.tableFooterView = self.footerView
        }
    }
    
    lazy var footerView: DailyCheckTaskFooterView = {
        return DailyCheckTaskFooterView.createFromXib()
    }()
    
    lazy var headerView: DailyCheckTaskHeaderView = {
        return DailyCheckTaskHeaderView.createFromXib()
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToCheckTaskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DailyCheckTaskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        do {
            let listener = try self.listener.unwrap()
            listener.queryDailyCheckTask()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = .white
    }
}

extension DailyCheckTaskViewController: DailyCheckTaskPagePresentable {
    func refreshSubviews(with task: MLDailyCheckTask) {
        do {
            let riskUnit = try task.risk.unwrap()
            self.title = riskUnit.unitName
            self.updateHeaderViewLayout(with: riskUnit)
            self.updateFooterViewLayout(with: riskUnit)
            self.updateSubmitButton(with: riskUnit)
            self.tableView.reloadData()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateSubmitButton(with risk: MLRiskDetailUnit) {
        let title = risk.status == "pending" ? "开始检查" : "检查详情"
        self.submitButton.setTitle(title, for: .normal)
    }
    
    func updateHeaderViewLayout(with risk: MLRiskDetailUnit) {
        self.headerView.refreshSubviews(with: risk)
        self.headerView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.tableView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.headerView
    }
    
    func updateFooterViewLayout(with risk: MLRiskDetailUnit) {
        self.footerView.refreshSubviews(with: risk)
        let remark: String = risk.remark.data()
        let width: CGFloat = MLConfigure.ScreenWidth - 30
        let height = remark.estimateHeight(with: 14, width: width, lineSpacing: 0)
        self.footerView.height = height + 110
    }
}

extension DailyCheckTaskViewController: DailyCheckTaskViewControllable {
    
}

extension DailyCheckTaskViewController: UITableViewDelegate {
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

extension DailyCheckTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(with: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DailyCheckTaskTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.querySolutionItem(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
    
    
}
