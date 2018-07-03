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
        let width = MLConfigure.screenWidth
        let frame = CGRect(x: 0, y: 0, width: width, height: 60)
        internalHeaderView.frame = frame
        return internalHeaderView
    }()
    
    lazy private var lineFooterView: UIView! = {
        let internalLineFooterView = UIView()
        let width = MLConfigure.screenWidth
        let frame = CGRect(x: 20, y: 0, width: width, height: 0.5)
        internalLineFooterView.frame = frame
        internalLineFooterView.backgroundColor = MLCommonColor.commonLine
        return internalLineFooterView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "我的"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
