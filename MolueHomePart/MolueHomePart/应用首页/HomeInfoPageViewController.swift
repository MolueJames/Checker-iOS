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


protocol HomeInfoPagePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    
    func jumpToDailyTaskController()
    
    func jumpToRiskCheckController()
    
    func jumpToNoticationController()
    
    func jumpToLegislationController()

    func jumpToRiskHistoryController()
    
    func jumpToDangerListController()
    
    var valueList:[String] {get}
}

final class HomeInfoPageViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: HomeInfoPagePresentableListener?
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: HomeInfoTableViewCell.self)
            headerView = HomeInfoTableHeaderView.createFromXib()
            headerView.frame = CGRect.init(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 385)
            tableView.tableHeaderView = headerView
        }
    }
    
    var headerView: HomeInfoTableHeaderView! {
        didSet {
            headerView.dailyTaskCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToDailyTaskController()
            }).disposed(by: disposeBag)
            headerView.riskCheckCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToRiskCheckController()
            }).disposed(by: disposeBag)
            headerView.notificationCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToNoticationController()
            }).disposed(by: disposeBag)
            headerView.legislationCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToLegislationController()
            }).disposed(by: disposeBag)
            headerView.riskHistoryCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToRiskHistoryController()
            }).disposed(by: disposeBag)
            headerView.dangerListCommand.subscribe(onNext: { [unowned self] (_) in
                self.listener?.jumpToDangerListController()
            }).disposed(by: disposeBag)
        }
    }
    
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
        
    }
    
    func updateUserInterfaceElements() {
        self.titleLabel.text = "安监通"
        self.navigationItem.titleView = titleLabel
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            MolueLogger.UIModule.error(error)
        }
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
}

extension HomeInfoPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.valueList.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HomeInfoTableViewCell.self)
        return cell
    }
}

extension HomeInfoPageViewController: HomeInfoPagePagePresentable {
    
}

extension HomeInfoPageViewController: HomeInfoPageViewControllable {
    
}


