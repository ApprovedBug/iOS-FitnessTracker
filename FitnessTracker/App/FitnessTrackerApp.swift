//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import SwiftUI
import SwiftData

@main
struct FitnessTrackerApp: App {
    
    init() {
        DependencyContainer.shared.registerDependencies()
    }

    var body: some Scene {
        
        @Inject
        var appConfigurationManager: AppConfigurationManaging
        
        WindowGroup {
            
            if !appConfigurationManager.getValue(for: .onboardingComplete) {
                WelcomeView(viewModel: WelcomeViewModel())
            } else {
                AppTabView()
            }
        }
    }
}
