//
//  MolueUtilitiesTests.swift
//  MolueUtilitiesTests
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest

@testable import MolueUtilities

class MolueUtilitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MolueLogger.enable = false
    }
    func testLogger() {
        MolueLogger.success.message("xxxxx")
        MolueLogger.failure.message("xxxxx")
        MolueLogger.warning.message("xxxxx")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
