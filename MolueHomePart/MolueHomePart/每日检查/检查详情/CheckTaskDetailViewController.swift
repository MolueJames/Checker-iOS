//
//  CheckTaskDetailViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation

protocol CheckTaskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func displayExistedRiskDetailController()
}

final class CheckTaskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskDetailPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: CheckTaskDetailTableViewCell.self)
            tableView.backgroundColor = UIColor.init(hex: 0xf5f5f9)
            tableView.tableFooterView = self.footerView
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    lazy var footerView: CheckTaskDetailFooterView = {
        let footerView: CheckTaskDetailFooterView = CheckTaskDetailFooterView.createFromXib()
        return footerView
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CheckTaskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = .white
        self.title = "风险详情"
    }
}

extension CheckTaskDetailViewController: CheckTaskDetailPagePresentable {
    
}

extension CheckTaskDetailViewController: CheckTaskDetailViewControllable {
    
}

extension CheckTaskDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskDetailTableViewCell.self)
        return cell
    }
}

extension CheckTaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            listener.displayExistedRiskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
