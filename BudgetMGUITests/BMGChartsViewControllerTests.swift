//
//  BMGChartsViewControllerTests.swift
//  BudgetMGUITests
//
//  Created by hmarker on 2021/2/17.
//

import XCTest
import BudgetMG

class BMGChartsViewControllerTests: XCTestCase {
    var app = XCUIApplication()
    let server = HttpServer()
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["-uitesting"]
    }
    
    override func tearDown() {
        server.stop()
    }
// TO DO:
    
    
    
    private func assertTableViewResult() {
        XCTContext.runActivity(named: "Test Successful TableView Screen") { _ in
            XCTAssert(app.tables[tableViewIdentifier].waitForExistence(timeout: 3))
            XCTAssert(app.tables[tableViewIdentifier].cells.count > 0)
            XCTAssert(app.staticTexts["9781788476249"].exists)
            XCTAssert(app.staticTexts["$44.99"].exists)
        }
    }
    
    
}
