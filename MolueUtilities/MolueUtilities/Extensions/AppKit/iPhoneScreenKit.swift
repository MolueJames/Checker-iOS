//
//  DeviceKit.swift
//  MolueUtilities
//
//  Created by MolueJames on 2018/10/14.
//  Copyright © 2018 MolueTech. All rights reserved.
//

import Foundation

public enum iPhoneScreenKit {
    case inch3_5
    case inch4_0
    case inch4_7
    case inch5_5
    case inch5_8
    case inch6_1
    case inch6_5
}

public extension iPhoneScreenKit {
    static func current() -> iPhoneScreenKit {
        switch (UIScreen.main.currentMode?.size)! {
        case CGSize(width: 320, height:568): return .inch4_0
        case CGSize(width: 375, height:667): return .inch4_7
        case CGSize(width: 414, height:736): return .inch5_5
        case CGSize(width:1125,height:2436): return .inch5_8
        case CGSize(width: 828,height:1792): return .inch6_1
        case CGSize(width:1242,height:2688): return .inch6_5
        default: return .inch3_5
        }
    }
    
    func deviceDefaultNavHeight() -> CGFloat {
        switch self {
        case .inch6_5, .inch6_1, .inch5_8: return 88;
        case .inch3_5, .inch4_0, .inch4_7, .inch5_5: return 64;
        }
    }
}
