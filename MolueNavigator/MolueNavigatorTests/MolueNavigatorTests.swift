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
    
    func testViewControllerWithParameter()  {
        let url = URL(string: "https://www.baidu.com?key=value")
        let aurl = MolueAppRouter.sharedInstance.updateURL(url!, parameters: ["name":"james","key":"Value"])
        let hope = "https://www.baidu.com?key=value&key=Value&name=james"
        XCTAssert(aurl.urlStringValue == hope, "the url is validate")
    }
    func testNavigatorRouter() {
        let string = MolueNavigatorRouter.init(.Home, path: "<path>").toString()
        let hope = "navigator://MolueHomePart/<path>"
        
        XCTAssert(hope == string!, "the url is validate")
    }
    
    func testWebsiteRouter() {
        let string = MolueWebsiteRouter.init(.HTTPS, path: "/<path:_>").toString()
        let hope = "https://<path:_>"
        XCTAssert(string! == hope, "the url is validate")
    }
    
    func testWebsiteRouter1() {
        let string = MolueWebsiteRouter.init(.HTTP, url: "www.baidu.com").toString()
        print(string)
        
    }
    
    func testAppRouter() {
        MolueAppRouter.sharedInstance.initialize()
        if let url = MolueNavigatorRouter.init(.Home, path: "userviewcontroller").toString() {
            MolueAppRouter.sharedInstance.navigator.viewController(for:url)
        }
    }
}
