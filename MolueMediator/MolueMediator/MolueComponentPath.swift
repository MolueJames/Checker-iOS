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
        case HomeInfoPage = "HomeInfoPageComponentBuilder"
        case DailyCheck = "DailyCheckTaskComponentBuilder"
        
        public func builderPath() -> String {
            return "MolueHomePart.\(self.rawValue)";
        }
    }
    
    public enum Mine: String, MolueBuilderPathProtocol {
        case UserCenter = "UserInfoCenterComponentBuilder"
        
        public func builderPath() -> String {
            return "MolueMinePart.\(self.rawValue)";
        }
    }
    
    public enum Risk: String, MolueBuilderPathProtocol {
        case RiskList = "PotentialRiskComponentBuilder"
        case QuickCheck = "QuickCheckRiskComponentBuilder"
        case EditRisk = "EditRiskInfoComponentBuilder"
        case RiskDetail = "RiskDetailComponentBuilder"
        case RiskFollow = "RiskFollowComponentBuilder"
        
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
    public enum Book: String, MolueBuilderPathProtocol {
        case BookInfo = "BookInfoComponentBuilder"
        case ChatPage = "AppChatPageComponentBuilder"
        
        public func builderPath() -> String {
            return "MolueBookPart.\(self.rawValue)";
        }
    }
    
    public enum Common: String, MolueBuilderPathProtocol {
        case CommonWeb = "CommonWebComponentBuilder"
        
        public func builderPath() -> String {
            return "MolueCommonPart.\(self.rawValue)";
        }
    }
}
