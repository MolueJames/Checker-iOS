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
    
    lazy var navBackgroundView: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0xB82D2)
        self.view.insertSubview(view, at: 0)
        return view
    }()
    
    open override func loadView() {
        super.loadView()
        guard let _ = self.navigationController else { return }
        self.navBackgroundView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(88)
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return.lightContent
        }
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
