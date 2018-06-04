//
//  SecurityAdministratorViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import RxSwift
import MolueNavigator
import MolueCommon
import MolueUtilities
import MolueFoundation
class SecurityAdministratorViewController: MLBaseViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewFooterView = AddAdministratorFooterView.createFromXib()
            tableViewFooterView.frame = CGRect(x: 0, y: 0, width:MLConfigure.screenWidth , height: 60)
            tableView.tableFooterView = tableViewFooterView
        }
    }
    
    var tableViewFooterView: AddAdministratorFooterView! {
        didSet {
            tableViewFooterView.addControlCommand.subscribe { _ in
                let router = MolueNavigatorRouter(.Home, path: HomeFilePath.AddAdministrator)
                MolueAppRouter.sharedInstance.pushRouter(router)
            }.disposed(by: disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "安全管理员"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
