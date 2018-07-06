//
//  RiskInfoViewController.swift
//  MolueRiskPart
//
//  Created by James on 2018/5/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

class RiskInfoViewController: MLBaseViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(xibWithCellClass: RiskInfoTableViewCell.self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    } ()
}

extension RiskInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "隐患列表"
        self.navigationItem.titleView = self.titleLabel
    }
}

extension RiskInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension RiskInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RiskInfoTableViewCell! = tableView.dequeueReusableCell(withClass: RiskInfoTableViewCell.self)
        if indexPath.row % 2 == 1 {
            cell.update(title:"哈哈占用、堵塞、封闭消防通道，妨碍逃生, 嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻嘻")
        } else {
            cell.update(title:"哈哈占用、堵塞、封闭消防通道，妨碍逃")
        }
        
        return cell
    }
}
