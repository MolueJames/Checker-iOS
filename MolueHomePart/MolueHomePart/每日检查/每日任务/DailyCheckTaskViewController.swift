//
//  DailyCheckTaskViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-11-05.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueUtilities

protocol DailyCheckTaskPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    
    func bindingTableViewAdapter(with tableView: UITableView)
}

final class DailyCheckTaskViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: DailyCheckTaskPresentableListener?
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension DailyCheckTaskViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "任务列表"
        do {
            let listener = try self.listener.unwrap()
            listener.bindingTableViewAdapter(with: self.tableView)
        } catch {
            MolueLogger.UIModule.error(error)
        }
    }
}

extension DailyCheckTaskViewController: DailyCheckTaskPagePresentable {
    
}

extension DailyCheckTaskViewController: DailyCheckTaskViewControllable {
    
}
