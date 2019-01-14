//
//  HomeInfoPageViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueFoundation
import MolueUtilities
import MolueMediator

protocol HomeInfoPagePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryAdvertisementList()
    
    func queryNotificationCommand() -> PublishSubject<Void>
    
    func queryLegislationCommand() -> PublishSubject<Void>
    
    func queryRiskHistoryCommand() -> PublishSubject<Void>
    
    func queryDangerListCommand() -> PublishSubject<Void>
    
    func queryDailyTaskCommand() -> PublishSubject<Void>
    
    func queryRiskCheckCommand() -> PublishSubject<Void>
}

final class HomeInfoPageViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: HomeInfoPagePresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: HomeInfoTableViewCell.self)
            tableView.tableHeaderView = self.headerView
        }
    }
    
    lazy var headerView: HomeInfoTableHeaderView! = {
        let headerView: HomeInfoTableHeaderView = HomeInfoTableHeaderView.createFromXib()
        headerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 385)
        do {
            let listener = try self.listener.unwrap()
            headerView.notificationCommand = listener.queryNotificationCommand()
            headerView.legislationCommand = listener.queryLegislationCommand()
            headerView.riskHistoryCommand = listener.queryRiskHistoryCommand()
            headerView.dangerListCommand = listener.queryDangerListCommand()
            headerView.dailyTaskCommand = listener.queryDailyTaskCommand()
            headerView.riskCheckCommand = listener.queryRiskCheckCommand()
        } catch { MolueLogger.UIModule.error(error) }
        return headerView
    }()
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 44))
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    } ()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HomeInfoPageViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        do {
            let listener = try self.listener.unwrap()
            listener.queryAdvertisementList()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "安全助手"
        self.navigationItem.titleView = titleLabel
    }
}

extension HomeInfoPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HomeInfoHeaderView.createFromXib()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
            
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension HomeInfoPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return 4
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeInfoTableViewCell.self)
        return cell
    }
}

extension HomeInfoPageViewController: HomeInfoPagePagePresentable {
    func refreshBannerList(with advertisement: [MLAdvertisement]) {
        
    }
}

extension HomeInfoPageViewController: HomeInfoPageViewControllable {
    
}


