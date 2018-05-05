//
//  MolueDatabaseTests.swift
//  MolueDatabaseTests
//
//  Created by James on 2018/5/5.
//  Copyright © 2018年 MolueTech. All rights reserved.
//

import XCTest
import MolueUtilities
@testable import MolueDatabase

class MolueDatabaseTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        MLDatabaseManager.shared.doConnection("333333")
        users.createOperation()
        var user = users.init()
        user.id = "123"
        user.name = "james"
        user.email = "james@qq.com"
//        users.insertOperation(user)
        
        let userlist:[users] = users.selectObjectOperation()
        MolueLogger.database.message(userlist)
        
        user.name = "alice"
        users.updateObjectOperation(user)
        
        let auserlist:[users] = users.selectObjectOperation()
        MolueLogger.database.message(auserlist)
    }
    
}
