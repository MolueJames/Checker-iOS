//
//  MoluePrintLog.swift
//  MolueSafty
//
//  Created by James on 2018/4/16.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public class Print {}

extension Print:MolueKitCompatible {}

public extension MolueKit where Base == Print {
    public static func log<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
