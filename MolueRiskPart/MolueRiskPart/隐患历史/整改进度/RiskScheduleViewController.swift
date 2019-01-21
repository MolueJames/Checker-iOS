//
//  RiskScheduleViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/20.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskSchedulePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilRectifyStep?
    
    func numberOfRows(at section: Int) -> Int?
    
    var moreCommand: PublishSubject<Void> { get }
}

final class RiskScheduleViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskSchedulePresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskScheduleTableViewCell.self)
            tableView.tableHeaderView = self.headerView
        }
    }

    lazy var headerView: RiskArrangeHeaderView = {
        let headerView: RiskArrangeHeaderView = RiskArrangeHeaderView.createFromXib()
        self.setupHeaderViewConfiguration(with: headerView)
        return headerView
    }()
    
    func setupHeaderViewConfiguration(with headerView: RiskArrangeHeaderView) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            headerView.refreshSubviews(with: item)
            headerView.moreCommand = listener.moreCommand
        } catch { MolueLogger.UIModule.error(error) }
    }

    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskScheduleViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "整改计划"
        self.updateHeaderViewLayout()
    }

    func updateHeaderViewLayout() {
        self.headerView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.tableView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.headerView
    }
}

extension RiskScheduleViewController: RiskSchedulePagePresentable {
    
}

extension RiskScheduleViewController: RiskScheduleViewControllable {
    
}

extension RiskScheduleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskScheduleTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskArrange(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }}

extension RiskScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: RiskArrangeSectionView = RiskArrangeSectionView.createFromXib()
        let title = section == 0 ? "隐患步骤(已完成)" : "隐患步骤(未完成)"
        header.refreshSubviews(with: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap() > 0 ? 35 : 0
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
