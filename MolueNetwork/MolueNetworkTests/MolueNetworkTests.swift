//
//  MolueNetworkTests.swift
//  MolueNetworkTests
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest
import MolueUtilities
import Alamofire
@testable import MolueNetwork

class MolueNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
//    func testAccountService()  {
//        let expectation = self.expectation(description: "request should succeed")
//        AccountService.appVersion(device: "iOS", version: "1.0.0").start({ (result:ResultEnum<MolueNetworkTestModel>) in
//            print(result)
//            expectation.fulfill()
//        }, delegate: nil)
//        waitForExpectations(timeout: 30, handler: nil)
//    }
    
    func testNetworkProvider() {
        let expectation = self.expectation(description: "request should succeed")
        let request = MolueDataRequest.init(parameter: ["channelCode": "DS0001"], method: .post, path: "/api/home")
        let manager = MolueRequestManager.init(request: request)
        manager.handleFailureResponse { (error) in
            print(error.localizedDescription)
            expectation.fulfill()
        }
        manager.handleSuccessResponse { (result) in
            print(result)
            expectation.fulfill()
        }
        manager.start()
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func test() {
        let expectation = self.expectation(description: "request should succeed")
        let request = MolueDataRequest.init(parameter: ["device": "iOS", "version": "1.0.0"], method: .get, path: "api/app/version")
        let manager = MolueRequestManager.init(request: request)
        manager.handleFailureResponse { (error) in
            print(error.localizedDescription)
            expectation.fulfill()
        }
        manager.handleSuccessResponse { (result) in
            print(result)
            expectation.fulfill()
        }
        manager.handleSuccessResultToObjc { (result: MolueNetworkTestModel?) in
            print(result)
            expectation.fulfill()
        }
        manager.start()
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
