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

enum Keys: String, AppConfigurationKey {
    
    case onboardingCompleted
    
    var name: String {
        return rawValue
    }
}
