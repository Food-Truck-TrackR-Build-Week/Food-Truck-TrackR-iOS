//
//  Food_Truck_TrackRUITests.swift
//  Food Truck TrackRUITests
//
//  Created by Elizabeth Thomas on 8/31/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import XCTest
@testable import Food_Truck_TrackR

class Food_Truck_TrackRUITests: XCTestCase {

    let app = XCUIApplication()

    func testCreateDinerAccount() {
        app.launch()
        app.buttons["A HUNGRY CUSTOMER 🌯"].tap()

        app.scrollViews.buttons["Create Account"].tap()

        app.textFields["EmailTextField"].tap()
        app.keys["b"].tap()

        app.secureTextFields["PasswordTextField"].tap()
        app.keys["b"].tap()

        app.secureTextFields["PasswordConfirmationTextField"].tap()
        app.keys["b"].tap()

        app.buttons["Create Account"].tap()
    }

    func testCreateOperatorAccount() {
        let oKey = app.keys["o"]
        app.launch()
        app.buttons["A FOOD TRUCK OWNER! 🚚"].tap()

        app.scrollViews.buttons["Create Account"].tap()

        app.textFields["EmailTextField"].tap()
        oKey.tap()

        app.secureTextFields["PasswordTextField"].tap()
        oKey.tap()

        app.secureTextFields["PasswordConfirmationTextField"].tap()
        oKey.tap()

        app.buttons["Create Account"].tap()
    }

    func testDinerLogin() {
        app.launch()
        dinerLogin()
    }

    func testOperatorLogin() {
        app.launch()
        operatorLogin()
    }

    func testViewingTruck() {
        app.launch()
        dinerLogin()

        app.tables.cells.firstMatch.tap()
    }

    func testRatingTruck() {
        app.launch()
        dinerLogin()

        app.tables.cells.firstMatch.tap()

        app.staticTexts["Review"].tap()
        tapOnFourthStar()

        app.buttons["Save"].tap()

    }

    func testCreatingTruck() {
        let oKey = app.keys["o"]
        app.launch()
        operatorLogin()

        app.buttons["Item"].tap()
        app.navigationBars["Profile"].buttons["Create a Truck"].tap()

        app.textFields["TruckNameTextField"].tap()
        oKey.tap()

        app.textFields["CuisineTypeTextField"].tap()
        oKey.tap()

        app.buttons["Save"].tap()

    }

    func dinerLogin() {
        let kKey = app.keys["k"]
        app.buttons["A HUNGRY CUSTOMER 🌯"].tap()

        app.scrollViews.textFields["Username"].tap()
        kKey.tap()

        app.secureTextFields["Password"].tap()
        kKey.tap()

        app.buttons["Sign In"].tap()
    }

    func operatorLogin() {
        let oKey = app.keys["o"]
        app.buttons["A FOOD TRUCK OWNER! 🚚"].tap()

        app.scrollViews.textFields["Username"].tap()
        oKey.tap()

        app.secureTextFields["Password"].tap()
        oKey.tap()

        app.buttons["Sign In"].tap()
    }

    func tapOnFourthStar() {
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .staticText).matching(identifier: "☆").element(boundBy: 3).tap()
    }

}
