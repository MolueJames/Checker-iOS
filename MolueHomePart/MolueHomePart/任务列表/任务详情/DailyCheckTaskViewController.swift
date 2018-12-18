//
//  DailyCheckTaskViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueCommon
import MolueMediator
import MolueFoundation
import MolueUtilities

protocol DailyCheckTaskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func jumpToCheckTaskDetailController()
    
    var currentItem: MLRiskTaskDetailModel? {get}
}

final class DailyCheckTaskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DailyCheckTaskPresentableListener?
    
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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: DailyCheckTaskTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableHeaderView = self.headerView
            self.headerView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
            }
            tableView.layoutIfNeeded()
            tableView.tableHeaderView = self.headerView
            
            tableView.tableFooterView = self.footerView
        }
    }
    
    lazy var footerView: DailyCheckTaskFooterView = {
        let footerView: DailyCheckTaskFooterView = DailyCheckTaskFooterView.createFromXib()
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.currentItem.unwrap()
            footerView.refreshSubviews(with: item)
            let remarks = try item.remark.unwrap()
            let width = MLConfigure.ScreenWidth - 30
            let height = remarks.estimateHeight(with: 14, width: width, lineSpacing: 3) + 110
            footerView.frame = CGRect(x: 0, y: 0, width: MLConfigure.ScreenWidth, height: height)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return footerView
    }()
    
    lazy var headerView: DailyCheckTaskHeaderView = {
        let headerView: DailyCheckTaskHeaderView = DailyCheckTaskHeaderView.createFromXib()
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.currentItem.unwrap()
            headerView.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return headerView
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonClicked(_ sender: UIButton) {
//        do {
//            let listener = try self.listener.unwrap()
//            let item = try listener.item.unwrap()
//            if (item.riskStatus == "已检查" || item.riskStatus == "有隐患") {
//                self.showWarningHUD(text: "该项目已检查")
//            } else {
//                listener.jumpToCheckTaskDetailController()
//            }
//        } catch {
//            MolueLogger.UIModule.error(error)
//        }
    }
}

extension DailyCheckTaskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.view.backgroundColor = .white
        do {
            let listener = try self.listener.unwrap()
            let item = try listener.currentItem.unwrap()
            self.title = item.name
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DailyCheckTaskViewController: DailyCheckTaskPagePresentable {
    
}

extension DailyCheckTaskViewController: DailyCheckTaskViewControllable {
    
}

extension DailyCheckTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: DailyCheckSectionHeaderView = DailyCheckSectionHeaderView.createFromXib()
        return headerView
    }
}

extension DailyCheckTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            let riskItem = try listener.currentItem.unwrap()
            let accidents = try riskItem.accidents.unwrap()
            return accidents.count
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: DailyCheckTaskTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let riskItem = try listener.currentItem.unwrap()
            let accidents = try riskItem.accidents.unwrap()
            let item = try accidents.item(at: indexPath.row).unwrap()
            cell.refreshSubviews(with: item)
        } catch {
            MolueLogger.UIModule.error(error)
        }
        return cell
    }
    
    
}
