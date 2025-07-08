//
//  MTG_LifecounterUITestsLaunchTests.swift
//  MTG LifecounterUITests
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import XCTest

final class MTG_LifecounterUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
