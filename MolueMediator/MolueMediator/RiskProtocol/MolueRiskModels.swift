//
//  MolueRiskModels.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/24.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation

public enum PotentialRiskStatus: CustomStringConvertible {
    case never //待整改
    case reform //整改中
    case finish //已整改
    case closed //已关闭
    
    public var description: String {
        switch self {
        case .never:
            return "暂未整改"
        case .reform:
            return "开始整改"
        case .finish:
            return "整改完成"
        case .closed:
            return "整改结束"
        }
    }
}

public enum PotentialRiskChannel: CustomStringConvertible {
    public var description: String {
        switch self {
        case .enterprise:
            return "企业自查"
        case .government:
            return "政府检查"
        }
    }
    
    case enterprise
    case government
}

public enum PotentialRiskLevel: CaseIterable, CustomStringConvertible {
    public var description: String {
        switch self {
        case .serious:
            return "重大事故隐患"
        case .general:
            return "一般事故隐患"
        case .higher:
            return "较高事故隐患"
        case .atLower:
            return "较低事故隐患"
        }
    }
    
    case serious
    case higher
    case general
    case atLower
}

public class PotentialRiskModel {
    public var status: PotentialRiskStatus?
    public var channel: PotentialRiskChannel?
    public var level: PotentialRiskLevel?
    public var riskClass: String?
    public var riskUnit: String?
    public var checkedDate: String?
    public var finishDate: String?
    public var closedData: String?
    public var checkedRiskPhotos: [UIImage]?
    public var finishedRiskPhotos: [UIImage]?
    public var riskDetail: String?
    public var finishDetail: String?
    public var arrangeModel: [Any]?
    public var personDetail: String?
    public init () {}
}
