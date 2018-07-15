//
//  MolueOnce.swift
//  MolueUtilities
//
//  Created by MolueJames on 2018/7/15.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var onceList: [String] = [String]()
    public static func doOnce(token: String = #file + #function, closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        if DispatchQueue.onceList.contains(token) {return}
        DispatchQueue.onceList.append(token)
        closure()
    }
}
