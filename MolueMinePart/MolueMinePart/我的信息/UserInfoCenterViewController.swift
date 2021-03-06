//
//  UserInfoCenterViewController.swift
//  MolueMinePart
//
//  Created by MolueJames on 2018/11/4.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueCommon
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol UserInfoCenterPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func bindingTableViewAdapter(with tableView: UITableView)
    
    func queryUserInfoFromServer()
    
    func queryUserInfoFromDatabase()
    
    func doUserLogoutOperater()
}

final class UserInfoCenterViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: UserInfoCenterPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableHeaderView = headerView
            tableView.tableFooterView = footerView
        }
    }
    
    lazy private var headerView: UserInfoCenterTableHeaderView! = {
        let headerView: UserInfoCenterTableHeaderView = UserInfoCenterTableHeaderView.createFromXib()
        headerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 75)
        return headerView
    }()
    
    lazy private var footerView: UserInfoCenterTableFooterView! = {
        let footerView: UserInfoCenterTableFooterView = UserInfoCenterTableFooterView.createFromXib()
        footerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 70)
        footerView.logoutCommand.subscribe(onNext: { [unowned self] (_) in
            self.listener?.doUserLogoutOperater()
        }).disposed(by: disposeBag)
        return footerView
    }()
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "个人信息"
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
        do {
            let listener = try self.listener.unwrap()
            listener.queryUserInfoFromDatabase()
            listener.queryUserInfoFromServer()
        } catch {
            MolueLogger.UIModule.message(error)
        }
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            MolueLogger.UIModule.message(error)
        }
        self.navigationItem.titleView = self.titleLabel
    }
}

extension UserInfoCenterViewController: UserInfoCenterPagePresentable {
    func refreshHeaderView(with user: MolueUserInfo) {
        self.headerView.refreshSubviews(with: user)
    }
}

extension UserInfoCenterViewController: UserInfoCenterViewControllable {
    
}
