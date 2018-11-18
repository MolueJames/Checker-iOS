//
//  RiskDetailViewController.swift
//  MolueRiskPart
//
//  Created by MolueJames on 2018/11/7.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueFoundation

protocol RiskDetailPresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
}

final class RiskDetailViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: RiskDetailPresentableListener?
    
    lazy var headerView: PotentialRiskHeaderView = {
        let headerView: PotentialRiskHeaderView = PotentialRiskHeaderView.createFromXib()
        self.view.addSubview(headerView)
        return headerView
    }()
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension RiskDetailViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        self.title = "隐患详情"
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigationView.snp.bottom)
        }
        
        self.headerView.layoutIfNeeded()
    }
}

extension RiskDetailViewController: RiskDetailPagePresentable {
    
}

extension RiskDetailViewController: RiskDetailViewControllable {
    
}
