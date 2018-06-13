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
    case EnterpriseInfo = "EnterpriseInformationViewController"
    /// 基本档案
    case BasicArchives = "BasicArchivesViewController"
    /// 联络信息
    case ContactInfo = "ContactInformationViewController"
    /// 危险特征
    case RiskFeature = "RiskFeatureViewController"
    /// 危险设备
    case HazardousMachinery = "HazardousMachineryViewController"
    /// 企业危险特征
    case EnterpriseRisk = "EnterpriseRiskFeatureViewController"
    /// 添加管理员
    case AddAdministrator = "AddSecurityAdministratorViewController"
    /// 安全管理员
    case SecurityAdministrator = "SecurityAdministratorViewController"
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
    case selectTable = "MLSelectedTableController"
    case datePicker = "MLDatePickerViewController"
}

