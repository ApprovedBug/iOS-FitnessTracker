//
//  AppConfigurationKeys.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 03/04/2024.
//

import ConfigurationManagement
import DependencyManagement
import DebugTools
import FitnessPersistence
import Foundation

enum DebugConfigurationKeys: String, AppConfigurationKey {
    
    case alwaysShowOnboarding
    
    init?(options: DebugMenuOptions) {
        
        switch options {
            case .alwaysShowOnboarding:
                self = .alwaysShowOnboarding
            default:
                return nil
        }
    }
    
    var name: String {
        return rawValue
    }
}

enum DebugMenuOptions: String, DebugMenuOption, CaseIterable {
    
    case alwaysShowOnboarding = "Always Show Onboarding"
    case resetOnboardingStatus = "Reset Onboarding Status"
    case resetGoals = "Reset Goals"
    case purgeAllData = "Purge All Data"
    
    var appConfigurationKey: AppConfigurationKey? {
        DebugConfigurationKeys(options: self)
    }
    
    var title: String {
        return rawValue
    }
    
    var type: DebugTools.DebugMenuOptionType {
        switch self {
            case .alwaysShowOnboarding:
                    .toggle
            case .resetOnboardingStatus:
                .button { resetOnboardingStatus() }
            case .resetGoals:
                .button { resetGoals() }
            case .purgeAllData:
                .button { purgeAllData() }
        }
    }
    
    func resetOnboardingStatus() {
        let appConfigurationManager = DependencyContainer.resolve(AppConfigurationManaging.self)
        appConfigurationManager?.setValue(value: false, key: Keys.onboardingCompleted)
    }
    
    func resetGoals() {
        let goalsRepository = DependencyContainer.resolve(GoalsRepository.self)
        goalsRepository?.deleteGoals(for: "current")
    }
    
    func purgeAllData() {
        resetOnboardingStatus()
        
        let contextProvider = DependencyContainer.resolve(ContextProviding.self)
        try? contextProvider?.sharedModelContainer.erase()
    }
}

enum Keys: String, AppConfigurationKey {
    
    case onboardingCompleted
    
    var name: String {
        return rawValue
    }
}
