//
//  RiskPlanedViewController.swift
//  MolueRiskPart
//
//  Created by JamesCheng on 2019-01-21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol RiskPlanedPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryHiddenPeril() -> MLHiddenPerilItem?
    
    func queryRiskArrange(with indexPath: IndexPath) -> MLPerilRectifyStep?
    
    func numberOfRows(at section: Int) -> Int?
    
    var moreCommand: PublishSubject<Void> { get }
}

final class RiskPlanedViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskPlanedPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(xibWithCellClass: RiskArrangeTableViewCell.self)
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskPlanedViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        
    }
}

extension RiskPlanedViewController: RiskPlanedPagePresentable {
    
}

extension RiskPlanedViewController: RiskPlanedViewControllable {
    
}

extension RiskPlanedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let count = listener.numberOfRows(at: section)
            return try count.unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: RiskScheduleTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryRiskArrange(with: indexPath)
            //            try cell.refreshSubviews(with: item.unwrap())
        } catch { MolueLogger.UIModule.error(error) }
        return cell
    }
}

extension RiskPlanedViewController: UITableViewDelegate {
    
}
