//
//  MolueNetwokTestModel.swift
//  MolueNetwork
//
//  Created by James on 2018/5/20.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper

public struct MolueNetworkTestModel:Mappable {
    var code: String?
    var data: String?
    public init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        code     <- map["code"]
        data     <- map["data"]
    }
}
