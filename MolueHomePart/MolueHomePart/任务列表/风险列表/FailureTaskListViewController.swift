//
//  FailureTaskListViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueFoundation

protocol FailureTaskListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows() -> Int?
    func queryTaskAttachment() -> MLTaskAttachment?
}

final class FailureTaskListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: FailureTaskListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: FailureTaskTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FailureTaskListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension FailureTaskListViewController: FailureTaskListPagePresentable {
    
}

extension FailureTaskListViewController: FailureTaskListViewControllable {
    
}

extension FailureTaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows().unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FailureTaskTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryTaskAttachment()
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
    
    
}

extension FailureTaskListViewController: UITableViewDelegate {
    
}
