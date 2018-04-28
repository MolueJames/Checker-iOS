//
//  HomeInforViewController.swift
//  MolueHomePart
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueCommon
import Permission
class HomeInforViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let button = UIButton.init(frame: CGRect.init(x: 40, y: 80, width: self.view.frame.size.width - 80, height: 45))
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
    }
    
    @IBAction func buttonClicked(button: Any?) {
        MoluePermission.camera { (status) in
            MolueLogger.success.message(status)
        }
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
