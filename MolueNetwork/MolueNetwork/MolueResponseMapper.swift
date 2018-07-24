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
        do {
            return try Mapper<Target>().map(JSONObject: result).unwrap()
        } catch {
            throw MolueStatusError.mapperResponseError
        }
    }
    
    public static func handleResultToList<Target: Mappable>(_ result: Any?) throws -> [Target] {
        do {
            let result = try (result as? [[String: Any]]).unwrap()
            return Mapper<Target>().mapArray(JSONArray: result)
        } catch {
            throw MolueStatusError.mapperResponseError
        }
    }
}

public extension MolueRequestManager {
    @discardableResult
    public func handleSuccessResultToObjc<T: Mappable>(_ success: MolueResultClosure<T?>?) -> MolueRequestManager {
        let resultClosure: MolueResultClosure<Any?> = { (result) in
            do {
                let response: T? = try MolueResponseMapper.handleResultToDict(result)
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
