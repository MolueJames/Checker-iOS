//
//  MolueRiskModels.swift
//  MolueMediator
//
//  Created by MolueJames on 2018/11/24.
//  Copyright © 2018 MolueJames. All rights reserved.
//

import Foundation


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
