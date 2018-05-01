//
//  MolueDatabaseTests.swift
//  MolueDatabaseTests
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest
import SQLite
import MolueUtilities
@testable import MolueDatabase

class MolueDatabaseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        do {
//            try MolueDBManager.shared.doConnection("xxx")
//            try MolueDBManager.shared.runCreateOperator("xxxx")
//        } catch {
//            MolueLogger.failure.message(error)
//        }
//
//       users.init().name = "xxx"
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
