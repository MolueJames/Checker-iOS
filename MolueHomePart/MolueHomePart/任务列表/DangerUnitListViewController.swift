//
//  DangerUnitListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueUtilities
import MolueFoundation

protocol DangerUnitListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var valueList: [String] {get}
    
    func jumpToDailyCheckTaskController()
    
    var selectedIndex: IndexPath {get set}
}

final class DangerUnitListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DangerUnitListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: DangerUnitTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DangerUnitListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "风险列表"
    }
}

extension DangerUnitListViewController: DangerUnitListPagePresentable {
    func popBackWhenTaskChecked() {
        self.tableView.reloadData()
        self.navigationController?.popToViewController(self, animated: true)
    }
    
}

extension DangerUnitListViewController: DangerUnitListViewControllable {
    
}

extension DangerUnitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: DangerUnitSectionHeaderView = DangerUnitSectionHeaderView.createFromXib()
        do {
            let list = AppHomeDocument.shared.unitList
            let item = try list.item(at: section).unwrap()
            headerView.refreshSubviews(with: item)
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
            listener.selectedIndex = indexPath
            listener.jumpToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DangerUnitListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppHomeDocument.shared.unitList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let unit = AppHomeDocument.shared.unitList[section]
        return unit.unitRisks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DangerUnitTableViewCell.self)
        do {
            let unitList = AppHomeDocument.shared.unitList
            let unitItem = try unitList.item(at: indexPath.section).unwrap()
            let riskList = try unitItem.unitRisks.unwrap()
            let riskItem = try riskList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: riskItem)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}
