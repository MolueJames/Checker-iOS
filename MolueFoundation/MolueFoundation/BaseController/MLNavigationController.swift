//
//  MLNavigationController.swift
//  MolueFoundation
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities

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
        do {
            let controller: MLNavigationProtocol = try viewController.toTarget()
            self.topViewController?.navigationItem.backBarButtonItem = controller.customBackBarButtonItem
        } catch {
            MolueLogger.UIModule.message(error)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        guard let items = navigationBar.items else {return false}
        if self.viewControllers.count < items.count {
            return true
        }
        do {
            let topViewController = try self.topViewController.unwrap()
            let viewController: MLNavigationPopProtocol = try topViewController.toTarget()
            viewController.navigationShouldPopOnBackButton(item)
        } catch {
            self.popViewController(animated: true)
        }
        for subview in navigationBar.subviews {
            UIView.animate(withDuration: 0.25, animations: { () in
                subview.alpha = 1
            })
        }
        return false
    }
}
