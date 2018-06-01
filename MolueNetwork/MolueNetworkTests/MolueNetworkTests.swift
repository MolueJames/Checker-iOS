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
        var manager = MolueRequestManager.init(request: request)
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
    
    func testLogin() {
        let expectation = self.expectation(description: "request should succeed")
        let headerInfo = Alamofire.Request.authorizationHeader(user: "hj8LAJukEhrs37yPbvXlwX5kG8sk45q0gciIw1Ol", password: "jEOk3ZLDixlJWPyyoncEbcwp4z3Ij5VG05HfKGORg5357CCWeRnrY86OPFpCPF79FaRiUGHnUcb68uCp5NScHg3z5roBqkVY3eB2LHrEaByULCY4JFMRDvXTa7a3ITq9")
        guard let header = headerInfo else {return}
        let xxx = [header.key : header.value]
        let dict = ["username":"13063745829", "password":"q1w2e3r4","grant_type":"password"]
        
        let request = MolueDataRequest.init(parameter:dict, method: .post, path: "oauth/token", headers: xxx)
        var manager = MolueRequestManager(request: request)
        manager.handleFailureResponse { (error) in
            print(error.localizedDescription)
            print(error)
            expectation.fulfill()
        }
        manager.handleSuccessResponse { (success) in
            print(success)
            expectation.fulfill()
        }
//        let credential = URLCredential.init(user: "13063745829", password: "q1w2e3r4", persistence: .none)
//        manager.start(usingCredential:credential)
        manager.start()
        waitForExpectations(timeout: 130, handler: nil)
    }
    
    func test() {
        let expectation = self.expectation(description: "request should succeed")
        let request = MolueDataRequest.init(parameter: ["device": "iOS", "version": "1.0.0"], method: .get, path: "api/app/version")
        var manager = MolueRequestManager.init(request: request)
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
    
    func testOauth() {
        let expectation = self.expectation(description: "request should succeed")
        let service = MolueOauthService.doLogin(username: "13063745829", password: "13063745829")
        service.handleSuccessResultToObjc { (result: MolueOauthModel?) in
            print(result)
            expectation.fulfill()
        }
        service.start()
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
