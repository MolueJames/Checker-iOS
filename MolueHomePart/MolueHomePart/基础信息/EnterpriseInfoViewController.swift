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
import RxSwift
protocol EnterpriseInfoNavigatorProtocol: MLAppNavigatorProtocol {
    func pushToController(path: String)
}

protocol EnterpriseInfoDataProtocol: MLListDataManagerProtocol {
    
}

class EnterpriseInfoViewController: MLBaseViewController {
    private let navigator: EnterpriseInfoNavigatorProtocol = EnterpriseInfoNavigator()
    private let dataManager: EnterpriseInfoDataProtocol = EnterpriseInfoDataManager()
    private let disposeBag = DisposeBag()
    private let test = PublishSubject<String>()
    
    @IBOutlet weak var informationTableView: UITableView! {
        didSet {
            informationTableView.delegate = self
            informationTableView.dataSource = self
            informationTableView.separatorStyle = .none
            informationTableView.register(xibWithCellClass: EnterpriseInfoTableViewCell.self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension EnterpriseInfoViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        test.subscribe(onNext: { (string) in
            let a = self.dataManager.count()
            print(a)
        }).disposed(by: disposeBag)
    }
    
    func updateUserInterfaceElements() {
        self.title = "基础信息"
    }
}

extension EnterpriseInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: EnterpriseInfoModel = self.dataManager.item(at: indexPath.row)
        self.navigator.pushToController(path: item.viewPath)
    }
}

extension EnterpriseInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.count()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: EnterpriseInfoTableViewCell.self)
        let item: EnterpriseInfoModel = self.dataManager.item(at: indexPath.row)
        cell.setEnterpriseInfoModel(item)
        return cell
    }
}
