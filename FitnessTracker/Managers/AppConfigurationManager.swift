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

enum AppConfigurationKey: String {
    case onboardingComplete = "OnboardingCompleted"
}

protocol AppConfigurationManaging {
    
    func getValue(for key: AppConfigurationKey) -> Bool
    func setValue(value: Bool, key: AppConfigurationKey)
}

class AppConfigurationManager: AppConfigurationManaging {
    
    @Inject
    var userDefaults: UserDefaultsProtocol

    init() { }

    func getValue(for key: AppConfigurationKey) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }
    
    func setValue(value: Bool, key: AppConfigurationKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
}
