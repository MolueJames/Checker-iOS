//
//  BasicInformationViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueNavigator
import MolueFoundation

protocol EnterpriseInfoNavigatorProtocol: MLAppNavigatorProtocol {
    func pushToController(path: String)
}

class EnterpriseInfoViewController: MLBaseViewController {
    internal var navigator: EnterpriseInfoNavigatorProtocol = EnterpriseInfoNavigator()
    internal var dataManager = EnterpriseInfoDataManager()
    
    @IBOutlet weak var informationTableView: UITableView! {
        didSet {
            informationTableView.delegate = self
            informationTableView.dataSource = self
            informationTableView.separatorStyle = .none
            informationTableView.register(xibWithCellClass: EnterpriseInfoTableViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "基础信息"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EnterpriseInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataManager.item(at: indexPath.row)
        self.navigator.pushToController(path: item.viewPath)
    }
}

extension EnterpriseInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EnterpriseInfoTableViewCell! = tableView.dequeueReusableCell(withClass: EnterpriseInfoTableViewCell.self)
        let item = self.dataManager.item(at: indexPath.row)
        cell.setEnterpriseInfoModel(item)
        return cell
    }
}
