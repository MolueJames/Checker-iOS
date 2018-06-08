//
//  AddSecurityAdministratorViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/6/1.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation
import MolueNavigator
class AddSecurityAdministratorViewController: MLBaseViewController, MolueNavigatorProtocol {
    func doTransferParameters(params: Any?) {
        
    }
    
    func doSettingParameters(params: Dictionary<String, String>) {
        guard let title = params["title"] else {
            self.title = "添加管理员"; return
        }
        self.title = title
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
