//
//  DispatchQueueExtensions.swift
//  MolueUtilities
//
//  Created by MolueJames on 2018/7/11.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform. or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

public struct GCDUtility {
    public static func onMain(block: @escaping ()->Void) {
        if Thread.isMainThread {
            block(); return
        }
        DispatchQueue.main.async {
            block()
        }
    }
}
