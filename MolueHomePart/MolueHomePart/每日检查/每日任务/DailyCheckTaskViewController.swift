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
    func jumpToCheckTaskDetailController()
}

final class DailyCheckTaskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DailyCheckTaskPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: DailyCheckTaskTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableHeaderView = self.headerView
            self.headerView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
            }
            tableView.tableFooterView = self.footerView
        }
    }
    
    lazy var footerView: DailyCheckTaskFooterView = {
        return DailyCheckTaskFooterView.createFromXib()
    }()
    
    lazy var headerView: DailyCheckTaskHeaderView = {
        return DailyCheckTaskHeaderView.createFromXib()
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.jumpToCheckTaskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DailyCheckTaskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = .white
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.tableView.layoutIfNeeded()
//        self.tableView.tableHeaderView = self.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return DailyCheckSectionHeaderView.createFromXib()
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
