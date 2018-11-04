//
//  UserInfoCenterViewController.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueFoundation
import MolueUtilities

protocol UserInfoCenterPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func bindingTableViewAdapter(with tableView: UITableView)
}

final class UserInfoCenterViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: UserInfoCenterPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = headerView
            tableView.tableFooterView = lineFooterView
        }
    }
    lazy private var headerView: UserInfoCenterTableHeaderView! = {
        let headerView: UserInfoCenterTableHeaderView = UserInfoCenterTableHeaderView.createFromXib()
        headerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 75)
        return headerView
    }()

    lazy private var lineFooterView: UIView! = {
        let lineFooterView = UIView()
        let frame = CGRect(x: 20, y: 0, width: MLConfigure.ScreenWidth, height: 0.5)
        lineFooterView.frame = frame
        lineFooterView.backgroundColor = MLCommonColor.commonLine
        return lineFooterView
    }()
    
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

extension UserInfoCenterViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "个人信息"
        self.navigationItem.titleView = self.titleLabel
        
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            
        }
    }
}

extension UserInfoCenterViewController: UserInfoCenterPagePresentable {
    
}

extension UserInfoCenterViewController: UserInfoCenterViewControllable {
    
}
