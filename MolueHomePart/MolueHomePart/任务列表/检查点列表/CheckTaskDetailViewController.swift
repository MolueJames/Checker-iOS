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
    
    func numberOfRows(in section: Int) -> Int?
    
    func postCheckTaskDetailToServer()
    
    func queryTaskSolution(with indexPath: IndexPath) -> MLRiskUnitSolution?
    
    func queryTaskAttachment(with indexPath: IndexPath) -> MLTaskAttachment?
    
    func updateAttachmentClosures(for cell: CheckTaskDetailTableViewCell)
    
    func queryCheckTaskName() -> String
}

final class CheckTaskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: CheckTaskDetailPresentableListener?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(xibWithCellClass: CheckTaskDetailTableViewCell.self)
            tableView.backgroundColor = UIColor.init(hex: 0xf5f5f9)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
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
            listener.postCheckTaskDetailToServer()
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
            self.title = listener.queryCheckTaskName()
        } catch { MolueLogger.UIModule.message(error)}
    }
}

extension CheckTaskDetailViewController: CheckTaskDetailPagePresentable {
    func reloadTableViewCell(for indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension CheckTaskDetailViewController: CheckTaskDetailViewControllable {
    
}

extension CheckTaskDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            let listener = try self.listener.unwrap()
            return try listener.numberOfRows(in: section).unwrap()
        } catch { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckTaskDetailTableViewCell.self)
        do {
            let listener = try self.listener.unwrap()
            let item = listener.queryTaskAttachment(with: indexPath)
            try cell.refreshSubviews(with: item.unwrap(), indexPath: indexPath)
            listener.updateAttachmentClosures(for: cell)
        } catch {
            MolueLogger.UIModule.message(error)
        }
        return cell
    }
}

extension CheckTaskDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
