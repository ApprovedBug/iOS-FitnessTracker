//
//  AppConfigurationManager.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 20/11/2023.
//

import Foundation

protocol UserDefaultsProtocol {
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}

class AppConfigurationManager {

    @Inject
    var userDefaults: UserDefaultsProtocol

    init() { }

    var onboardingCompleted: Bool {
        get {
            userDefaults.bool(forKey: "OnboardingCompleted")
        }
        set {
            userDefaults.set(newValue, forKey: "OnboardingCompleted")
        }
    }
}
