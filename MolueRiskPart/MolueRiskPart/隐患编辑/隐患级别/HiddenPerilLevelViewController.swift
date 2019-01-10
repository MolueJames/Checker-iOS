//
//  HiddenPerilLevelViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-10.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol HiddenPerilLevelPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows() -> Int
    
    func queryPotentialRiskLevel(with indexPath: IndexPath) -> PotentialRiskLevel?
    
    func submitPotentialRiskLevel(with indexPath: IndexPath?)
}

final class HiddenPerilLevelViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: HiddenPerilLevelPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.register(xibWithCellClass: HiddenPerilListTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HiddenPerilLevelViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患级别"
        
        let rightItem = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(rightItemClicked))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            let indexPath = self.tableView.indexPathForSelectedRow
            listener.submitPotentialRiskLevel(with: indexPath)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension HiddenPerilLevelViewController: HiddenPerilLevelPagePresentable {
    
}

extension HiddenPerilLevelViewController: HiddenPerilLevelViewControllable {
    
}

extension HiddenPerilLevelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.numberOfRows()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HiddenPerilListTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryPotentialRiskLevel(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}

extension HiddenPerilLevelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
