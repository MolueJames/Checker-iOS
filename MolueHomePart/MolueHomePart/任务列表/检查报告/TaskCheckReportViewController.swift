//
//  TaskCheckReportViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-24.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueFoundation

protocol TaskCheckReportPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class TaskCheckReportViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: TaskCheckReportPresentableListener?
    
    @IBOutlet weak var doneCheckButton: UIButton! {
        didSet {
            let appDefault = MLCommonColor.appDefault
            doneCheckButton.setColor(.lightGray, state: .disabled)
            doneCheckButton.setColor(appDefault, state: .normal)
        }
    }
    
    @IBOutlet weak var insertRiskButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.allowsMultipleSelectionDuringEditing = true
            tableView.register(xibWithCellClass: TaskCheckReportTableViewCell.self)
            tableView.register(xibWithCellClass: PotentialRiskTableViewCell.self)
        }
    }
    
    private var rightButtonItem: UIBarButtonItem {
        let image: UIImage? = UIImage(named: "danger_risk_done")
        let action: Selector? = #selector(rightItemClicked)
        return UIBarButtonItem(image: image, style: .done, target: self, action: action)
    }
    
    private var closeButtonItem: UIBarButtonItem {
        let image: UIImage? = UIImage(named: "task_report_close")
        let action: Selector? = #selector(closeItemClicked)
        return UIBarButtonItem(image: image, style: .done, target: self, action: action)
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func insertRiskButtonClicked(_ sender: UIButton) {
        let isEditing:Bool = self.tableView.isEditing
        self.tableView.setEditing(!isEditing, animated: true)
        let title:String = isEditing ? "添加隐患" : "取消添加"
        self.insertRiskButton.setTitle(title, for: .normal)
        self.doneCheckButton.isEnabled = isEditing
        let rightItem = isEditing ? nil : rightButtonItem
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @IBAction func rightItemClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func closeItemClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func doneCheckButtonClicked(_ sender: UIButton) {
        
    }
    
    private var selectedIndexRow = [Int]()
    
}

extension TaskCheckReportViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.navigationItem.leftBarButtonItem = closeButtonItem
        self.title = "检查报告"
    }
}

extension TaskCheckReportViewController: TaskCheckReportPagePresentable {
    
}

extension TaskCheckReportViewController: TaskCheckReportViewControllable {
    
}

extension TaskCheckReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 142 : 90
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: TaskCheckReportTableViewCell.self)
            cell.selectionStyle = indexPath.row == 0 ? .none : .blue
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: PotentialRiskTableViewCell.self)
            return cell
        }
    }
}
