//
//  MockUserDefaults.swift
//  FitnessTrackerTests
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation

@testable import FitnessTracker

class MockUserDefaults: UserDefaultsProtocol {
    private var store: [String: Any] = [:]

    func bool(forKey defaultName: String) -> Bool {
        return store[defaultName] as? Bool ?? false
    }

    func set(_ value: Bool, forKey defaultName: String) {
        store[defaultName] = value
    }
}
