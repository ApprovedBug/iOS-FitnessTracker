//
//  AppConfigurationKeys.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 03/04/2024.
//

import DependencyManagement
import Foundation
import DebugTools
import ConfigurationManagement

enum DebugConfigurationKeys: String, AppConfigurationKey {
    
    case alwaysShowOnboarding
    case resetOnboardingStatus
    case resetGoals
    
    init(options: DebugMenuOptions) {
        
        switch options {
            case .alwaysShowOnboarding:
                self = .alwaysShowOnboarding
            case .resetOnboardingStatus:
                self = .resetOnboardingStatus
            case .resetGoals:
                self = .resetGoals
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
    
    var appConfigurationKey: AppConfigurationKey {
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
                .button {
                    let appConfigurationManager = DependencyContainer.resolve(AppConfigurationManaging.self)
                    appConfigurationManager?.setValue(value: false, key: Keys.onboardingCompleted)
                }
            case .resetGoals:
                .button {
                    let goalsRepository = DependencyContainer.resolve(GoalsRepository.self)
                    goalsRepository?.deleteGoals(for: "current")
                }
        }
    }
}

enum Keys: String, AppConfigurationKey {
    
    case onboardingCompleted
    
    var name: String {
        return rawValue
    }
}
