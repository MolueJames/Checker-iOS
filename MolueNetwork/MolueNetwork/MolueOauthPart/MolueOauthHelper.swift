//
//  MolueOauthHelper.swift
//  MolueNetwork
//
//  Created by James on 2018/5/30.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import Foundation
import Alamofire
import MolueUtilities

private let secret = "v2J5dobvIPYJLuVHNOlvYFWfAnhUokY1TppV1t5DHDKXJXAcW8kSMdzN6NKfrPZuSJLt62TVDV1HKX0sNEmreZPr7iplJ7CuxtLVUvQd8YbV1U1tlBYCc0anLJsrh6u4"
private let appKey = "biSNqztvIm9QW4GqCNHoTwWBiTrpq89M9xFjnq3J"

public struct MolueOauthHelper {
    
    public static func queryClientInfoHeaders() -> [String : String]? {
        do {
            let header = Request.authorizationHeader(user: appKey, password: secret)
            let authHeader = try header.unwrap()
            return [authHeader.key: authHeader.value]
        } catch {
            return MolueLogger.network.returnNil(error)
        }
    }

    public static func queryUserOauthHeaders() -> [String : String]? {
        do {
            let item = try MolueOauthModel.queryOauthItem().unwrap()
            let access_token = try item.access_token.unwrap()
            let token_type = try item.token_type.unwrap()
            let authorization = token_type + " " + access_token
            return ["authorization" : authorization]
        } catch {
            return MolueLogger.network.allowNil(error)
        }
    }
    
    public static func queryRefreshToken() -> String? {
        do {
            let item = try MolueOauthModel.queryOauthItem().unwrap()
            return try item.refresh_token.unwrap()
        } catch {
            return MolueLogger.network.allowNil(error)
        }
    }
}
