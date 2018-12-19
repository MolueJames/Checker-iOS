//
//  PolicyNoticeViewController.swift
//  MolueHomePart
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import UIKit
import MolueUtilities
import MolueFoundation
import MolueNetwork

protocol PolicyNoticePresentableListener: class {
    // 定义一些当前页面需要的业务逻辑, 比如网络请求.
    func queryPolicyNoticeList()
    
    func morePolicyNoticeList()
    
    func numberOfRows(in section: Int) -> Int?
    
    func queryPolicyNotice(with indexPath: IndexPath) -> MLPolicyNoticeModel?
    
    func jumpToPolicyNoticeDetail(with indexPath: IndexPath)
}

final class PolicyNoticeViewController: MLBaseViewController  {
    //MARK: View Controller Properties
    var listener: PolicyNoticePresentableListener?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension PolicyNoticeViewController: MLUserInterfaceProtocol {
    func queryInformationWithNetwork() {
        
    }
    
    func updateUserInterfaceElements() {
        do {
            let listener = try self.listener.unwrap()
            listener.queryPolicyNoticeList()
        } catch { MolueLogger.UIModule.error(error) }
    }
}

extension PolicyNoticeViewController: PolicyNoticePagePresentable {
    func reloadTableViewData() {
        
    }
    
    func endHeaderRefreshing() {
        
    }
    
    func endFooterRefreshing(with hasMore: Bool) {
        
    }
}

extension PolicyNoticeViewController: PolicyNoticeViewControllable {
    
}
