//
//  CheckTaskHistoryViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/11/18.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueFoundation

protocol CheckTaskHistoryPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    var valueList: [DangerUnitRiskModel] {get}
    
    func jumpToTaskHistoryController(with item: DangerUnitRiskModel)
}

final class CheckTaskHistoryViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskHistoryPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: CheckTaskHistoryTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CheckTaskHistoryViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "检查历史"
    }
}

extension CheckTaskHistoryViewController: CheckTaskHistoryPagePresentable {
    
}

extension CheckTaskHistoryViewController: CheckTaskHistoryViewControllable {
    
}

extension CheckTaskHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.valueList.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskHistoryTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.valueList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}

extension CheckTaskHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.valueList.item(at: indexPath.row).unwrap()
            listener.jumpToTaskHistoryController(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
