//
//  EnterpriseInfoModel.swift
//  MolueHomePart
//
//  Created by James on 2018/6/3.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import RxSwift
import MolueCommon

public struct EnterpriseInfoModel {
    private(set) var color: UIColor
    private(set) var imageName: String
    private(set) var title: String
    private(set) var description: String
    private(set) var viewPath: String
    
    static func defaultValues() -> [EnterpriseInfoModel]?{
//        let model1 = EnterpriseInfoModel(color: UIColor.init(hex: 0x1B82D2), imageName: "enterprise_info_basic", title: "基本档案", description: "更新日期：2018.12.1", viewPath: HomePath.BasicArchives.rawValue)
//        let model2 = EnterpriseInfoModel(color: UIColor.init(hex: 0x43C6A4), imageName: "enterprise_info_contact", title: "联络信息", description: "更新日期：2018.12.1", viewPath: HomePath.ContactInfo.rawValue)
//        let model3 = EnterpriseInfoModel(color: UIColor.init(hex: 0xFFC30C), imageName: "enterprise_info_feature", title: "危险特征", description: "未更新", viewPath: HomePath.DangerousFeature.rawValue)
//        let model4 = EnterpriseInfoModel(color: UIColor.init(hex: 0x999999), imageName: "enterprise_info_manager", title: "安全管理员", description: "1人，更新日期：2018.12.1", viewPath: HomePath.SecurityAdmini.rawValue)
        return nil
    }
}

