//
//  RiskFollowViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskFollowPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func numberOfRows(in section: Int) -> Int
    
    func jumpToRiskDetailController()
    
    func queryPerilAction(with indexPath: IndexPath) -> MLHiddenPerilAction?
    
    var moreCommand: PublishSubject<Void> { get }
}

final class RiskFollowViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskFollowPresentableListener?
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskFollowTableViewCell.self)
            tableView.tableHeaderView = self.headerView
        }
    }
    
    lazy var headerView: RiskArrangeHeaderView = {
        let headerView: RiskArrangeHeaderView = RiskArrangeHeaderView.createFromXib()
        self.setupHeaderViewConfiguration(with: headerView)
        return headerView
    }()
    
    func setupHeaderViewConfiguration(with headerView: RiskArrangeHeaderView) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            headerView.refreshSubviews(with: item)
            headerView.moreCommand = listener.moreCommand
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskFollowViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患追踪"
        self.updateHeaderViewLayout()
    }
    
    func updateHeaderViewLayout() {
        self.headerView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.tableView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.headerView
    }
}

extension RiskFollowViewController: RiskFollowPagePresentable {
    
}

extension RiskFollowViewController: RiskFollowViewControllable {
    
}

extension RiskFollowViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return listener.numberOfRows(in: section)
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskFollowTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(in: indexPath.section) - 1
            let position = RiskFollowPosition.create(with: indexPath.row, max: count)
            let item = listener.queryPerilAction(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap(), position: position)
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}

extension RiskFollowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension RiskFollowViewController: UISearchBarDelegate {
    
}
