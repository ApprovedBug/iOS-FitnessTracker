//
//  AppConfigurationKeys.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 03/04/2024.
//

import Foundation
import DebugTools
import ConfigurationManagement

enum DebugCongigurationKeys: String, AppConfigurationKey {
    
    case alwaysShowOnboarding
    
    init(options: DebugMenuOptions) {
        
        switch options {
            case .alwaysShowOnboarding:
                self = .alwaysShowOnboarding
        }
    }
    
    var name: String {
        return rawValue
    }
}

enum DebugMenuOptions: String, DebugMenuOption, CaseIterable {
    
    case alwaysShowOnboarding = "Always show onboarding"
    
    var appConfigurationKey: AppConfigurationKey {
        DebugCongigurationKeys(options: self)
    }
    
    var title: String {
        return rawValue
    }
}

enum Keys: String, AppConfigurationKey {
    
    case onboardingCompleted
    
    var name: String {
        return rawValue
    }
}
