//
//  AppConfigurationManagerTests.swift
//  FitnessTrackerTests
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation
import XCTest

@testable import FitnessTracker

class AppConfigurationManagerTests: XCTestCase {

    var settingsManager: AppConfigurationManager!
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        settingsManager = AppConfigurationManager()
    }

    override func tearDown() {
        settingsManager = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testOnboardingCompletedInitiallyFalse() {
        XCTAssertFalse(settingsManager.onboardingCompleted)
    }

    func testOnboardingCompletedSetAndGet() {
        // Set onboardingCompleted to true
        settingsManager.onboardingCompleted = true

        // Verify that the value is correctly set
        XCTAssertTrue(settingsManager.onboardingCompleted)

        // Reset the value to false
        settingsManager.onboardingCompleted = false

        // Verify that the value is correctly set to false
        XCTAssertFalse(settingsManager.onboardingCompleted)
    }

    // Add more tests for other settings as needed
}
