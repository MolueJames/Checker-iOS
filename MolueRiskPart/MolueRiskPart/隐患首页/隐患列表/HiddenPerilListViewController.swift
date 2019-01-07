//
//  HiddenPerilListViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/6.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities

protocol HiddenPerilListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(in section: Int) -> Int?
    
    func didSelectRow(at indexPath: IndexPath)
}

final class HiddenPerilListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: HiddenPerilListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: PotentialRiskTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HiddenPerilListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension HiddenPerilListViewController: HiddenPerilListPagePresentable {
    
}

extension HiddenPerilListViewController: HiddenPerilListViewControllable {
    
}

extension HiddenPerilListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(in: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: PotentialRiskTableViewCell.self)
        
        return cell
    }
}

extension HiddenPerilListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.didSelectRow(at: indexPath)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
