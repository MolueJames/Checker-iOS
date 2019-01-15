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

protocol EnterpriseInfoDataProtocol {
    
}

class EnterpriseInfoViewController: MLBaseViewController {
    
    private let disposeBag = DisposeBag()
    
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
    }
}

extension EnterpriseInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: EnterpriseInfoTableViewCell.self)
        return cell
    }
}
