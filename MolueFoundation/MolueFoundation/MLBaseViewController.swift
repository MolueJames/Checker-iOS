//
//  MLBaseViewController.swift
//  MolueFoundation
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import SnapKit
import MolueUtilities

open class MLBaseViewController: UIViewController, MLNavigationProtocol {
    
    public var networkcount = 0
    
    private lazy var navBackgroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xB82D2)
        self.view.insertSubview(view, at: 0)
        return view
    }()

    open override func loadView() {
        super.loadView()
        self.updateNavBackgroundView()
    }
    
    private func updateNavBackgroundView() {
        guard let navController = self.navigationController else { return }
        guard let view = navController.navigationBar.subviews.first else { return }
        self.navBackgroundView.frame = CGRect.init(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateNavBackgroundView()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.edgesForExtendedLayout = .all;
        self.view.backgroundColor = UIColor.init(hex: 0xf5f5f9)
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


