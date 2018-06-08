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
    private var modelList: [EnterpriseInfoModel] = []
    
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
        self.modelList = self.dataSource()
        self.title = "基础信息"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func dataSource() -> [EnterpriseInfoModel] {
        var list = [EnterpriseInfoModel]()
        self.addInfoToModelList(lists: &list, model: EnterpriseInfoModel(color: UIColor.init(hex: 0x1B82D2), imageName: "enterprise_info_basic", title: "基本档案", description: "更新日期：2018.12.1", viewPath: HomePath.BasicArchives.rawValue))
        self.addInfoToModelList(lists: &list, model: EnterpriseInfoModel(color: UIColor.init(hex: 0x43C6A4), imageName: "enterprise_info_contact", title: "联络信息", description: "更新日期：2018.12.1", viewPath: HomePath.ContactInfo.rawValue))
        self.addInfoToModelList(lists: &list, model: EnterpriseInfoModel(color: UIColor.init(hex: 0xFFC30C), imageName: "enterprise_info_feature", title: "危险特征", description: "未更新", viewPath: HomePath.RiskFeature.rawValue))
        self.addInfoToModelList(lists: &list, model: EnterpriseInfoModel(color: UIColor.init(hex: 0x999999), imageName: "enterprise_info_manager", title: "安全管理员", description: "1人，更新日期：2018.12.1", viewPath: HomePath.SecurityAdministrator.rawValue))
        return list
    }
    
    private func addInfoToModelList(lists: inout [EnterpriseInfoModel], model: EnterpriseInfoModel) {
        objc_sync_enter(self)
        defer {objc_sync_exit(self)}
        lists.append(model)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EnterpriseInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelList[indexPath.row]
        let router = MolueNavigatorRouter(.Home, path: model.viewPath)
        MolueAppRouter.sharedInstance.pushRouter(router)
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
