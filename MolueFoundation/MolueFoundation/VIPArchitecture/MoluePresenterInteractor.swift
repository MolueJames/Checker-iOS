//
//  MolueInteractor.swift
//  MolueFoundation
//
//  Created by MolueJames on 2018/9/22.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities

public protocol MolueInteractorPresentable: class {}

open class MoluePresenterInteractor<PresenterTarget> {
    public let presenter: PresenterTarget
    
    public init(presenter: PresenterTarget) {
        self.presenter = presenter
    }
    
    deinit {
        MolueLogger.dealloc.message(String(describing: self))
    }
}
