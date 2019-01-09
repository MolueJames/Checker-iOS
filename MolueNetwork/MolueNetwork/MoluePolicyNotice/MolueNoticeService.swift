//
//  MoluePolicyNoticeService.swift
//  MolueNetwork
//
//  Created by JamesCheng on 2018-12-19.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

public struct MolueNoticeService {
    public static func queryPolicyNoticeList(page: Int, size: Int) -> MolueDataRequest {
        let parameters = ["page": page, "page_size": size]
        return MolueDataRequest(parameter: parameters, method: .get, path: "api/document/received_notification/")
    }
    
    public static func signPolicyNotification(with noticeId: Int) -> MolueDataRequest {
        let path = "api/document/received_notification/\(noticeId)/"
        let parameters = ["signed" : true]
        return MolueDataRequest(parameter: parameters, method: .put, path: path)
    }
    
    public static func readPolicyNotification(with noticeId: Int) -> MolueDataRequest {
        let path = "api/document/received_notification/\(noticeId)/"
        let parameters = ["read" : true]
        return MolueDataRequest(parameter: parameters, method: .put, path: path)
    }
    
//    public static func searchPolicyNoticeList(with text: String) -> MolueDataRequest {
//
//    }
}
