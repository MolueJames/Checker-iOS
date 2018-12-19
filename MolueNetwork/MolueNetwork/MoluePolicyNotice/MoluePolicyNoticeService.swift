//
//  MoluePolicyNoticeService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

public struct MoluePolicyNoticeService {
    public static func queryPolicyNoticeList(page: Int, pagesize: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": pagesize]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/document/received_notification/")
    }
    
    public static func signaturePolicyNotice(with noticeId: String) {
        
    }
    
    public static func searchPolicyNoticeList(with text: String) {
        
    }
}
