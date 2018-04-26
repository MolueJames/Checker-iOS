//
//  MolueNetworkTests.swift
//  MolueNetworkTests
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest
import Moya
import MolueUtilities
@testable import MolueNetwork

class MolueNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    func testNetworkProvider() {
        let expectation = self.expectation(description: "request should succeed")
        AccountService.appVersion(device: "iOS", version: "1.1.0").start(success: { (map) in
            MolueLogger.network.message(map)
            expectation.fulfill()
        }, failure: { (error) in
            MolueLogger.failure.message(error)
            expectation.fulfill()
        })
        
        AccountService.appVersion(device: "iOS", version: "1.1.0").start(MoyaProvider<MolueNetworkProvider>(), success: { (map) in
            MolueLogger.network.message(map)
            expectation.fulfill()
        }, failure: { (error) in
            MolueLogger.failure.message(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 30, handler: nil)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
