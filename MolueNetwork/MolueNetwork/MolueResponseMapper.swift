//
//  MolueResponseMapper.swift
//  MolueNetwork
//
//  Created by James on 2018/5/25.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import ObjectMapper
import MolueUtilities

private struct MolueResponseMapper {
    public static func handleResultToDict<Target: Mappable>(_ result: Any?) throws -> Target {
        guard let object = Mapper<Target>().map(JSONObject: result) else {
            throw MolueStatusError.mapperResponseError
        }
        return object
    }
    
    public static func handleResultToList<Target: Mappable>(_ result: Any?) throws -> [Target] {
        guard let result = result as? [[String: Any]] else {
            throw MolueStatusError.mapperResponseError
        }
        return Mapper<Target>().mapArray(JSONArray: result)
    }
}

public extension MolueRequestManager {
    @discardableResult
    public func handleSuccessResultToObjc<T: Mappable>(_ success: MolueResultClosure<T?>?) -> MolueRequestManager {
        let resultClosure: MolueResultClosure<Any?> = { (result) in
            do {
                let response:T? = try MolueResponseMapper.handleResultToDict(result)
                success?(response)
            } catch {
                MolueLogger.failure.error(error)
            }
        }
        self.handleSuccessResponse(resultClosure)
        return self
    }
    @discardableResult
    public func handleSuccessResultToList<T: Mappable>(_ success: MolueResultClosure<[T]?>?) -> MolueRequestManager {
        let resultClosure: MolueResultClosure<Any?> = { (result) in
            do {
                let response:[T]? = try MolueResponseMapper.handleResultToList(result)
                success?(response)
            } catch {
                MolueLogger.failure.error(error)
            }
        }
        self.handleSuccessResponse(resultClosure)
        return self
    }
}
