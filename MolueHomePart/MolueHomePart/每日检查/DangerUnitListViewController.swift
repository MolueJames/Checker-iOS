//
//  DangerUnitListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation

protocol DangerUnitListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var valueList: [String] {get}
    
    func jumpToDailyCheckTaskController()
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
    
}

extension DangerUnitListViewController: DangerUnitListViewControllable {
    
}

extension DangerUnitListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DangerUnitSectionHeaderView.createFromXib()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
            listener.jumpToDailyCheckTaskController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DangerUnitListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DangerUnitTableViewCell.self)
        return cell
    }
}
