//
//  MolueComponentPath.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/10/1.
//  Copyright © 2018年 MolueJames. All rights reserved.
//

import Foundation

public protocol MolueBuilderPathProtocol {
    func builderPath() -> String
}

public enum MolueComponent {
    public enum Home: String, MolueBuilderPathProtocol {
        /// 应用首页
        case HomePageInfo = "HomeInfoViewController"
        /// 基础信息
        case EnterpriseInfo = "EnterpriseInfoViewController"
        /// 基本档案
        case BasicArchives = "BasicArchivesViewController"
        /// 联络信息
        case ContactInfo = "ContactInfoViewController"
        /// 危险特征
        case DangerousFeature = "RiskFeatureViewController"
        /// 危险设备
        case DangerMachinery = "DangerMachineryViewController"
        /// 企业危险特征
        case EnterpriseRisk = "EnterpriseRiskViewController"
        /// 添加管理员
        case IncreaseAdmini = "IncreaseAdminiViewController"
        /// 安全管理员
        case SecurityAdmini = "SecurityAdminiViewController"
        /// 隐患自查
        case SelfRiskCheck = "SelfRiskCheckViewController"
        /// 政策通知
        case PolicyNotice = "PolicyNoticeViewController"
        /// 法律法规
        case LawRegulation = "LawRegulationViewController"
        
        public func builderPath() -> String {
            return "MolueHomePart.\(self.rawValue)";
        }
    }
    
    public enum Mine: String, MolueBuilderPathProtocol {
        public func builderPath() -> String {
            return "MolueMinePart.\(self.rawValue)";
        }
    
        case UserCenter = "UserInfoCenterComponentBuilder"
    }
    
    public enum Risk: String, MolueBuilderPathProtocol {
        case RiskList = "PotentialRiskComponentBuilder"
        
        public func builderPath() -> String {
            return "MolueRiskPart.\(self.rawValue)"
        }
    }
    
    public enum Login: String, MolueBuilderPathProtocol {
        case LoginPage = "UserLoginPageComponentBuilder"
        case ForgetPwd = "ForgetPasswordComponentBuilder"
        public func builderPath() -> String {
            return "MolueLoginPart.\(self.rawValue)";
        }
    }
    
}
