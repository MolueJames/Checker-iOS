//
//  MLSelectedTableViewModel.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public struct MLSelectedTableViewModel: MLMutipleSectionProtocol {
    public var description: String {
        return title
    }
    
    private var title: String
    public var selected: Bool
    private(set) var keyPath: String
    
    public mutating func updateValue(select: Bool) {
        self.selected = select
    }
    
    public init(title: String, select: Bool, keyPath: String) {
        self.title = title
        self.selected = select
        self.keyPath = keyPath
    }
}
