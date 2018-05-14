//
//  MLNavigationController.swift
//  MolueFoundation
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
protocol MLNavigationProtocol {
    var customBackBarButtonItem: UIBarButtonItem {get}
}
extension MLNavigationProtocol {
    var customBackBarButtonItem: UIBarButtonItem { get {
            return UIBarButtonItem.init(title: "返回", style: .plain, target: nil, action: nil)
        }
    }
}
open class MLNavigationController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return.lightContent
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }

 
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? MLNavigationProtocol {
            self.topViewController?.navigationItem.backBarButtonItem = controller.customBackBarButtonItem
        }
        super.pushViewController(viewController, animated: animated)
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
