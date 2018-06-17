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
class EnterpriseInformationViewController: MLBaseViewController {
    private var modelList = EnterpriseInfoModel.defaultValues()
    
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

extension EnterpriseInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelList[indexPath.row]
        let router = MolueNavigatorRouter(.Home, path: model.viewPath)
        MolueAppRouter.shared.pushRouter(router)
    }
}

extension EnterpriseInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EnterpriseInfoTableViewCell! = tableView.dequeueReusableCell(withClass: EnterpriseInfoTableViewCell.self)
        cell.setEnterpriseInfoModel(self.modelList[indexPath.row])
        return cell
    }
}
