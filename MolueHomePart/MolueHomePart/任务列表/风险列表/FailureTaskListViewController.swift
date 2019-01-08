//
//  FailureTaskListViewController.swift
//  MolueHomePart
//
//  Created by MolueJames on 2018/12/31.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueUtilities
import MolueCommon
import MolueMediator
import MolueFoundation

protocol FailureTaskListPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func numberOfRows() -> Int?
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment?
    
    func queryRiskUnitName() -> String
    
    func queryRiskCommand() -> PublishSubject<FailureAttachment>
    
    func postCheckFinishNotification()
    
}

final class FailureTaskListViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: FailureTaskListPresentableListener?

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
            tableView.register(xibWithCellClass: FailureTaskTableViewCell.self)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBAction func leftBarItemClicked(item: UIBarButtonItem) {
        do {
            let listener = try self.listener.unwrap()
            listener.postCheckFinishNotification()
        } catch { MolueLogger.UIModule.error(error) }
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        do {
            let listener = try self.listener.unwrap()
            listener.postCheckFinishNotification()
        } catch {
            MolueLogger.UIModule.error(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FailureTaskListViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            self.title = listener.queryRiskUnitName()
        } catch {
            MolueLogger.UIModule.error(error)
        }
        let image = UIImage(named: "task_report_close")
        let item = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(leftBarItemClicked))
        self.navigationItem.leftBarButtonItem = item
        
        self.view.backgroundColor = .white
    }
}

extension FailureTaskListViewController: FailureTaskListPagePresentable {
    
}

extension FailureTaskListViewController: FailureTaskListViewControllable {
    
}

extension FailureTaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows().unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: FailureTaskTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryTaskAttachment(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap(), indexPath: indexPath)
            cell.riskCommand = listener.queryRiskCommand()
        } catch { MolueLogger.UIModule.message(error) }
        return cell
    }
}

extension FailureTaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
