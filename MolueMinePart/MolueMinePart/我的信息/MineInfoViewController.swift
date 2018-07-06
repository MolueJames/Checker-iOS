//
//  MineInformationViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities
import MolueCommon
class MineInfoViewController: MLBaseViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(xibWithCellClass: MineInfoTableViewCell.self)
            tableView.tableHeaderView = headerView
            tableView.tableFooterView = lineFooterView
        }
    }
    lazy private var headerView: MineInfoTableHeaderView! = {
        let internalHeaderView: MineInfoTableHeaderView = MineInfoTableHeaderView.createFromXib()
        let frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 60)
        internalHeaderView.frame = frame
        return internalHeaderView
    }()
    lazy private var lineFooterView: UIView! = {
        let internalLineFooterView = UIView()
        let frame = CGRect(x: 20, y: 0, width: MLConfigure.ScreenWidth, height: 0.5)
        internalLineFooterView.frame = frame
        internalLineFooterView.backgroundColor = MLCommonColor.commonLine
        return internalLineFooterView
    }()
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    } ()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MineInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "个人信息"
        self.navigationItem.titleView = self.titleLabel
    }
}

extension MineInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MineInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MineInfoTableViewCell.self)!
        return cell
    }
}
