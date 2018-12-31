//
//  TaskCheckReportViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueMediator
import MolueCommon
import MolueFoundation

protocol TaskCheckReportPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows(in section: Int) -> Int?
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment?
}

final class TaskCheckReportViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: TaskCheckReportPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.register(xibWithCellClass: TaskCheckReportTableViewCell.self)
            tableView.register(xibWithCellClass: PotentialRiskTableViewCell.self)
        }
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension TaskCheckReportViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "检查报告"
    }
}

extension TaskCheckReportViewController: TaskCheckReportPagePresentable {
    
}

extension TaskCheckReportViewController: TaskCheckReportViewControllable {
    
}

extension TaskCheckReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 142 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "相关隐患" : nil
    }
}

extension TaskCheckReportViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: TaskCheckReportTableViewCell.self)
            do {
                let listener = try self.listener.unwrap()
                let attachment = listener.queryTaskAttachment(with: indexPath)
                try cell.refreshSubviews(with: attachment.unwrap())
            } catch {
                MolueLogger.UIModule.message(error)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: PotentialRiskTableViewCell.self)
            return cell
        }
    }
}
