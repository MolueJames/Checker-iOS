//
//  RiskPointListViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2019-02-12.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskPointListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskPointListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskPointListPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
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

extension RiskPointListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskPointListViewController: RiskPointListPagePresentable {
    
}

extension RiskPointListViewController: RiskPointListViewControllable {
    
}

extension RiskPointListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            
        } catch { return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: <#T##T.Type#>)
    }
    
    
}

extension RiskPointListViewController: UITableViewDelegate {
    
}
