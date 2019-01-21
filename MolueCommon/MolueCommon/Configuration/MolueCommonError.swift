//
//  MolueCommonError.swift
//  MolueCommon
//
//  Created by MolueJames on 2019/1/21.
//  Copyright © 2019 MolueTech. All rights reserved.
//

import Foundation

public struct MolueCommonError: LocalizedError {
    private var message: String
    public init(with message: String) {
        self.message = message
    }
    public var errorDescription: String? {
        return message
    }
}
