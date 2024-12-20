//
//  AppRootManager.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 28/10/2024.
//

import ConfigurationManagement
import DependencyManagement
import Foundation

protocol AppRootManaging {
    func switchRoot(to: AppRoot)
}

class AppViewModel: ObservableObject, AppRootManaging {
    
    @Published var root: AppRoot = .splash
    
    @Inject
    var appConfigurationManager: AppConfigurationManaging
    
    let welcomeViewModel: WelcomeViewModel
    let appTabViewModel: AppTabViewModel
    
    @MainActor
    init() {
        welcomeViewModel = WelcomeViewModel()
        appTabViewModel = AppTabViewModel()
        
        setInitialRoot()
    }
    
    func setInitialRoot() {
        
        guard !appConfigurationManager.getValue(for: DebugConfigurationKeys.alwaysShowOnboarding) else {
            self.root = .welcome
            return
        }
    
        guard appConfigurationManager.getValue(for: Keys.onboardingCompleted) else {
            self.root = .welcome
            return
        }
        
        self.root = .dashboard
    }
    
    func switchRoot(to: AppRoot) {
        
        self.root = to
    }
}

enum AppRoot {
    case splash
    case welcome
    case dashboard
}
