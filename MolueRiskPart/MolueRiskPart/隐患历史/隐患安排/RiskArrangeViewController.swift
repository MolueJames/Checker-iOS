//
//  RiskArrangeViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import MolueMediator
import IQKeyboardManagerSwift
import MolueFoundation
import MolueUtilities
import RxSwift
import SnapKit
import UIKit

protocol RiskArrangePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(at section: Int) -> Int?
    
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func querySubmitCommand() -> PublishSubject<Void>
    
    func queryFinishCommand() -> PublishSubject<Void>
    
    func queryBudgetCommand() -> PublishSubject<Void>
    
    func queryDetailCommand() -> PublishSubject<Void>
    
    func querySituation(with indexPath: IndexPath) -> MLPerilSituation?
    
    func uploadHiddenPerilArrange()
}

final class RiskArrangeViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskArrangePresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskArrangeTableViewCell.self)
            tableView.tableHeaderView = self.headerView
        }
    }
    
    lazy var footerView: RiskArrangeFooterView = {
        let footerView: RiskArrangeFooterView = RiskArrangeFooterView.createFromXib()
        self.setupFooterViewConfiguration(with: footerView)
        self.view.addSubview(footerView)
        return footerView
    }()
    
    lazy var headerView: RiskArrangeHeaderView = {
        let headerView: RiskArrangeHeaderView = RiskArrangeHeaderView.createFromXib()
        headerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 180)
        self.setupHeaderViewConfiguration(with: headerView)
        return headerView
    }()
    
    func setupFooterViewConfiguration(with footerView: RiskArrangeFooterView) {
        do {
            let listener = try self.listener.unwrap()
            let submitCommand = listener.querySubmitCommand()
            footerView.updateSubmitCommand(with: submitCommand)
            let finishCommand = listener.queryFinishCommand()
            footerView.updateFinishCommand(with: finishCommand)
            let budgetCommand = listener.queryBudgetCommand()
            footerView.updateBudgetCommand(with: budgetCommand)
        } catch {MolueLogger.UIModule.error(error)}
    }
    
    func setupHeaderViewConfiguration(with headerView: RiskArrangeHeaderView) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            headerView.refreshSubviews(with: item)
            let detailCommand = listener.queryDetailCommand()
            headerView.updateDetailCommand(with: detailCommand)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskArrangeViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患安排"
        self.footerView.snp.makeConstraints({ [unowned self] (make) in
            make.top.equalTo(self.tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        })
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            listener.uploadHiddenPerilArrange()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension RiskArrangeViewController: RiskArrangePagePresentable {
    func refreshFinishDate(with title: String) {
        self.footerView.updateFinishDate(with: title)
    }
    
    func refreshBudgetFrom(with title: String) {
        self.footerView.updateBudgetFrom(with: title)
    }
    
    func reloadTableViewCell() {
        self.tableView.reloadData()
    }
}

extension RiskArrangeViewController: RiskArrangeViewControllable {
    
}

extension RiskArrangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskArrangeTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.querySituation(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }
}

extension RiskArrangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return RiskArrangeSectionView.createFromXib()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
