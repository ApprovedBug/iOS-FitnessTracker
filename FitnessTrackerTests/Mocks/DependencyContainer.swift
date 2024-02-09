//
//  DependencyContainer.swift
//  FitnessTrackerTests
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation

@testable import FitnessTracker

// Extension for testability
extension DependencyContainer {
    static func forTesting() -> DependencyContainer {
        let container = DependencyContainer()
        // Register mocks or test-specific dependencies here
        container.register(UserDefaultsProtocol.self) {
            MockUserDefaults()
        }
        return container
    }
}
