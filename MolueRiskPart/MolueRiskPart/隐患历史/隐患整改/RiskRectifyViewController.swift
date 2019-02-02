//
//  RiskRectifyViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskRectifyPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLHiddenPerilSituation?
    
    func numberOfRows(at section: Int) -> Int?
    
    var moreCommand: PublishSubject<Void> { get }
}

final class RiskRectifyViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskRectifyPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskArrangeTableViewCell.self)
            tableView.allowsMultipleSelectionDuringEditing = true
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
    
    lazy var rightItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "选择步骤", style: .done, target: self, action: #selector(rightItemClicked))
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskRectifyViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.navigationItem.rightBarButtonItem = self.rightItem
        self.updateHeaderViewLayout()
        self.title = "隐患整改"
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        let select: Bool = !self.tableView.isEditing
        self.tableView.setEditing(select, animated: true)
        sender.title = select ? "取消" : "选择步骤"
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

extension RiskRectifyViewController: RiskRectifyPagePresentable {
    
}

extension RiskRectifyViewController: RiskRectifyViewControllable {
    
}

extension RiskRectifyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskArrangeTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskArrange(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }
}

extension RiskRectifyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: RiskArrangeSectionView = RiskArrangeSectionView.createFromXib()
        let title = section == 0 ? "隐患步骤(已完成)" : "隐患步骤(未完成)"
        header.refreshSubviews(with: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap() > 0 ? 35 : 0
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? false : true
    }
}
