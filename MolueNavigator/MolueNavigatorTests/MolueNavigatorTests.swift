//
//  MolueNavigatorTests.swift
//  MolueNavigatorTests
//
//  Created by James on 2018/4/17.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest

@testable import MolueNavigator

class MolueNavigatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeUserViewControllerPath() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testWebsiteURLIsValidate() {
//        let path = MolueNavigatorRouter.init(.Home).toPath("<path>")
        let newquery = QueryUtilities.query(["name":"james","key":"Value"])
        let apath = MolueNavigatorRouter.init(.Home, path: "/<path>",query: newquery).toString()
        print(apath ?? "a")
    }
    
    func testNavigatorRouter() {
        let string = MolueNavigatorRouter.init(.Home, path: "<path>").toString()
        let hope = "navigator://MolueHomePart/<path>"
        
        XCTAssert(hope == string!, "the url is validate")
    }
    
    func testWebsiteRouter() {
        let string = MolueWebsiteRouter.init(.HTTPS, path: "<path:_>").toPath()
        let hope = "https://<path:_>"
        XCTAssert(string! == hope, "the url is validate")
    }
    
    func testWebsiteRouter1() {
//        let string = MolueWebsiteRouter.init(.HTTPS, url: "https://www.baidu.com").toString()
//        print(string ?? "nil")
        let path = MolueWebsiteRouter.init(.HTTPS, path: "<path:_>").toPath()
        print(path)
        let url = MolueWebsiteRouter.init(url: "http://www.baidu.com/vdad").toString()
        print(url ?? "nil")
    }
    
    func testAppRouter() {
        MolueAppRouter.sharedInstance.initialize()
        if let url = MolueNavigatorRouter.init(.Home, path: "userviewcontroller").toString() {
            MolueAppRouter.sharedInstance.navigator.viewController(for:url)
        }
    }
}
