//
//  MLSingleSectionTableModel.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public struct MLSingleSectionTableModel: MLSingleSelectProtocol {
    public var description: String {
        return title
    }
    
    private(set) var title: String
    private(set) var keyPath: String
    
    public init(title: String, keyPath: String) {
        self.title = title
        self.keyPath = keyPath
    }
}
