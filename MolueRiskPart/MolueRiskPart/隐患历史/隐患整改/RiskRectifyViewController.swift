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
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilSituation?
    
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
            tableView.tableFooterView = self.footerView
        }
    }
    
    lazy var footerView: RiskRectifyFooterView = {
        let footerView: RiskRectifyFooterView = RiskRectifyFooterView.createFromXib()
        footerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 155)
        self.setupFooterViewConfiguration(with: footerView)
        return footerView
    }()
    
    lazy var headerView: RiskArrangeHeaderView = {
        let headerView: RiskArrangeHeaderView = RiskArrangeHeaderView.createFromXib()
        headerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: 180)
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
    
    func setupFooterViewConfiguration(with footerView: RiskRectifyFooterView) {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.queryHiddenPeril().unwrap()
            footerView.refreshSubviews(with: item)
        } catch { MolueLogger.UIModule.error(error) }
    }
    
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
        self.title = "隐患整改"
    }
}

extension RiskRectifyViewController: RiskRectifyPagePresentable {
    
}

extension RiskRectifyViewController: RiskRectifyViewControllable {
    
}

extension RiskRectifyViewController: UITableViewDataSource {
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
        return RiskArrangeSectionView.createFromXib()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
