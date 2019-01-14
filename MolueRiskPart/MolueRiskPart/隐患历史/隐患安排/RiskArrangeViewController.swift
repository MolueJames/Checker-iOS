//
//  RiskArrangeViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-07.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskArrangePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryHiddenPeril() -> MLHiddenPerilItem?
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
            tableView.tableFooterView = self.footerView
        }
    }
    
    lazy var footerView: UIButton = {
        let width: CGFloat = MLConfigure.ScreenWidth
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 45))
        button.setTitle("添加整改计划", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: 0xFF0000)
        return button
    }()
    
    lazy var headerView: RiskArrangeDetailHeaderView = {
        let headerView: RiskArrangeDetailHeaderView = RiskArrangeDetailHeaderView.createFromXib()
        let width: CGFloat = MLConfigure.ScreenWidth
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: 400)
        return headerView
    }()
    
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
        let rightItem = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(rightItemClicked))
        self.navigationItem.rightBarButtonItem = rightItem
        
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            self.headerView.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
    }
}

extension RiskArrangeViewController: RiskArrangePagePresentable {
    
}

extension RiskArrangeViewController: RiskArrangeViewControllable {
    
}

extension RiskArrangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskArrangeTableViewCell.self)
        return cell
    }
    
}

extension RiskArrangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
