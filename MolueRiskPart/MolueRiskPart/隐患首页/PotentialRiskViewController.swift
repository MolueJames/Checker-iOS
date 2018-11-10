//
//  PotentialRiskViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/10/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities

protocol PotentialRiskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func bindingTableViewAdapter(with tableView: UITableView)
}

final class PotentialRiskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PotentialRiskPresentableListener?
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    } ()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PotentialRiskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "隐患列表"
        self.navigationItem.titleView = self.titleLabel
        
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension PotentialRiskViewController: PotentialRiskPagePresentable {
    
}

extension PotentialRiskViewController: PotentialRiskViewControllable {
    
}
