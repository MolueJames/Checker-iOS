//
//  RiskInfoViewController.swift
//  MolueRiskPart
//
//  Created by James on 2018/5/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

class RiskInfoViewController: MLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "隐患"
        self.view.backgroundColor = UIColor.init(hex: 0xcccccc)
        self.navigationItem.titleView = searchBar
        self.updateNavigationView(height: 76)
        self.updateNavigationView(color: .clear)
    }
    
    lazy var searchBar: UISearchBar! = {
        let searchBar = UISearchBar()
        return searchBar
    } ()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
