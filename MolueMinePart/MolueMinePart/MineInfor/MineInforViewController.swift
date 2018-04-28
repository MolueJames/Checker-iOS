//
//  MineInforViewController.swift
//  MolueMinePart
//
//  Created by James on 2018/4/27.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueNavigator
class MineInforViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let alertButton = UIButton.init(frame: CGRect.init(x: 40, y: 80, width: self.view.frame.width - 80, height: 45))
        alertButton.backgroundColor = UIColor.red
        alertButton.addTarget(self, action: #selector(alertButtonClicked), for: .touchUpInside)
        self.view.addSubview(alertButton)
        
        let navigatorButton = UIButton.init(frame: CGRect.init(x: 40, y: 140, width: self.view.frame.width - 80, height: 45))
        navigatorButton.backgroundColor = UIColor.red
        navigatorButton.addTarget(self, action: #selector(navigatorButtonClicked), for: .touchUpInside)
        self.view.addSubview(navigatorButton)
    }
    
    @IBAction func alertButtonClicked(button: Any?) {
        let action = UIAlertAction.init(title: "ok", style: .default) { (action) in
            MolueLogger.success.message(action)
        }
        MolueAppRouter.sharedInstance.showAlert(MolueDoAlertRouter.init(.alert, title: "title", message: "message"), actions:[action])
    }
    
    @IBAction func navigatorButtonClicked(button: Any?) {
        MolueAppRouter.sharedInstance.presentRouter(MolueNavigatorRouter.init(.Home, path: "HomeInforViewController"))
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
