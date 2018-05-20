//
//  MolueNetworkPlugin.swift
//  MolueNetwork
//
//  Created by James on 2018/5/20.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import MolueUtilities
import Result
import Moya

public protocol NetworkActivityDelegate: NSObjectProtocol {
    func networkActivityBegin(target: MolueNetworkProvider)
    func networkActivityEnded(target: MolueNetworkProvider)
}

public struct MolueNetworkPlugin: PluginType {
    private let pluginLock = NSLock()
    public weak var delegate: NetworkActivityDelegate?
    
    public init(delegate: NetworkActivityDelegate?) {
        self.delegate = delegate
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        MolueLogger.network.message(request)
        pluginLock.lock()
        defer {
            pluginLock.unlock()
        }
        guard let target = target as? MolueNetworkProvider, let delegate = self.delegate else {return}
        delegate.networkActivityBegin(target: target)
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        MolueLogger.network.message(result)
        pluginLock.lock()
        defer {
            pluginLock.unlock()
        }
        guard let target = target as? MolueNetworkProvider, let delegate = self.delegate else {return}
        delegate.networkActivityEnded(target: target)
    }
    
}
