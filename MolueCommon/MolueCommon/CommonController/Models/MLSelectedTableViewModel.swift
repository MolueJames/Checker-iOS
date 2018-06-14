//
//  MLSelectedTableViewModel.swift
//  MolueCommon
//
//  Created by MolueJames on 2018/6/14.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public struct MLSelectedTableViewModel {
    var title: String
    var selected: Bool
    var keyPath: String
    public init(title: String, select: Bool, keyPath: String) {
        self.title = title
        self.selected = select
        self.keyPath = keyPath
    }
}
