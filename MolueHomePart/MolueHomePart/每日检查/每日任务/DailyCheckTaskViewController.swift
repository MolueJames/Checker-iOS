//
//  DailyCheckTaskViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities

protocol DailyCheckTaskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class DailyCheckTaskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DailyCheckTaskPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: DailyCheckTaskTableViewCell.self)
            tableView.tableHeaderView = headerView
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    lazy var headerView: DailyCheckTaskHeaderView = {
        let view: DailyCheckTaskHeaderView = DailyCheckTaskHeaderView.createFromXib()
        return view
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DailyCheckTaskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "风险详情"
    }
}

extension DailyCheckTaskViewController: DailyCheckTaskPagePresentable {
    
}

extension DailyCheckTaskViewController: DailyCheckTaskViewControllable {
    
}

extension DailyCheckTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DailyCheckTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DailyCheckTaskTableViewCell.self)
        return cell
    }
    
    
}
