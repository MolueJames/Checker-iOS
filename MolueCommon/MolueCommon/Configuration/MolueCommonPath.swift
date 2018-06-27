//
//  MolueController.swift
//  MolueCommon
//
//  Created by James on 2018/4/28.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities

public enum HomePath: String {
    /// 应用首页
    case HomePageInfo = "HomeInfoViewController"
    /// 基础信息
    case EnterpriseInfo = "EnterpriseInfoViewController"
    /// 基本档案
    case BasicArchives = "BasicArchivesViewController"
    /// 联络信息
    case ContactInfo = "ContactInfoViewController"
    /// 危险特征
    case DangerousFeature = "DangerousFeatureViewController"
    /// 危险设备
    case DangerMachinery = "DangerMachineryViewController"
    /// 企业危险特征
    case EnterpriseRisk = "EnterpriseRiskViewController"
    /// 添加管理员
    case IncreaseAdmini = "IncreaseAdminiViewController"
    /// 安全管理员
    case SecurityAdmini = "SecurityAdminiViewController"
}

public enum MinePath: String {
    /// 个人信息
    case MineInfo = "MineInformationViewController"
}

public enum RiskPath: String {
    case RiskInfo = "RiskInfoViewController"
}

public enum BookPath: String {
    case BookInfo = "BookInfoViewController"
}

public enum CommonPath: String {
    case datePicker = "MLDatePickerViewController"
}

