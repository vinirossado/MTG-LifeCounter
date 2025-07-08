//
//  MTG_L        continueAfterFailure = falsenterUITests.swift
//  MTG LifecounterUITests
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import XCTest

final class MTG_LifecounterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Clean up after each test
    }

    @MainActor
    func testGameLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the app launches successfully
        XCTAssertTrue(app.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
