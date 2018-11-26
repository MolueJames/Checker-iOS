//
//  CheckTaskDetailViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-06.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueMediator
import MolueUtilities
import MolueFoundation

protocol CheckTaskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func jumpToTaskDetailController()
    var selectedIndex: IndexPath {get}
    var item: DangerUnitRiskModel? {get set}
}

final class CheckTaskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskDetailPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: CheckTaskDetailTableViewCell.self)
            tableView.backgroundColor = UIColor.init(hex: 0xf5f5f9)
            tableView.tableFooterView = self.footerView
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    lazy var footerView: CheckTaskDetailFooterView = {
        let footerView: CheckTaskDetailFooterView = CheckTaskDetailFooterView.createFromXib()
        return footerView
    }()
    
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.layer.masksToBounds = false
            let color = MLCommonColor.titleLabel.cgColor
            submitButton.layer.borderColor = color
            submitButton.layer.shadowOffset = CGSize(width: 0, height: -1)
            submitButton.layer.shadowRadius = 1;
            submitButton.layer.shadowOpacity = 0.2
        }
    }
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            var item = try listener.item.unwrap()
            item.riskStatus = "已检查"
            listener.item = item
            AppHomeDocument.shared.taskList.append(item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension CheckTaskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = .white
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.item.unwrap()
            self.title = item.riskName
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension CheckTaskDetailViewController: CheckTaskDetailPagePresentable {
    
}

extension CheckTaskDetailViewController: CheckTaskDetailViewControllable {
    
}

extension CheckTaskDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.item.unwrap()
            let list = try item.riskMeasure.unwrap()
            return list.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskDetailTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let taskItem = try listener.item.unwrap()
            let taskList = try taskItem.riskMeasure.unwrap()
            let item = try taskList.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
}

extension CheckTaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let listener = try self.listener.unwrap()
//            listener.displayExistedRiskDetailController()
            listener.jumpToTaskDetailController()
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}
