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
        WindowGroup {
            
            if !AppConfigurationManager().onboardingCompleted {
                OnboardingView(viewModel: OnboardingViewModel())
            } else {
                AppTabView()
            }
        }
    }
}
