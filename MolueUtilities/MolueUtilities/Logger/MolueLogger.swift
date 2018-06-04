//
//  MolueLogger.swift
//  MolueUtilities
//
//  Created by James on 2018/4/25.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation

public enum MolueLogger: String {
    public static var enable: Bool = true
    case warning = "⚠️"
    case success = "✅"
    case failure = "❎"
    case network = "⛅"
    case dealloc = "♻️"
    case database = "📚"
    case UIModule = "🎬"
    
    public func message<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        if MolueLogger.enable {
            print("\((file as NSString).lastPathComponent)-Line:\(line)-Method:\(method) \(self.rawValue): \(message)")
        }
    }
    
    public func error<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        #if DEBUG
            fatalError("\((file as NSString).lastPathComponent)-Line:\(line)-Method:\(method) \(self.rawValue): \(message)")
        #else
            print("\((file as NSString).lastPathComponent)-Line:\(line)-Method:\(method) \(self.rawValue): \(message)")
        #endif
    }
}
