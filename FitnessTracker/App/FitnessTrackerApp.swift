//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 22/10/2023.
//

import Combine
import ConfigurationManagement
import DebugTools
import DependencyManagement
import FitnessPersistence
import SwiftUI
import SwiftData
import UIKit

@main
struct FitnessTrackerApp: App {
    
    init() {
        registerDependencies()
    }
    
    func registerDependencies() {
        let persistenceManager = PersistenceManager()
        
        // Register your dependencies here
        DependencyContainer.register(ContextProviding.self) { persistenceManager }
        DependencyContainer.register(UserDefaultsProtocol.self) { UserDefaults.standard }
        
        DependencyContainer.register(GoalsRepository.self) {
            LocalGoalsRepository(modelContainer: persistenceManager.sharedModelContainer)
        }
        DependencyContainer.register(DiaryRepository.self) {
            LocalDiaryRepository(modelContainer: persistenceManager.sharedModelContainer)
        }
        DependencyContainer.register(FoodItemRepository.self) {
            LocalFoodItemRepository(modelContainer: persistenceManager.sharedModelContainer)
        }
        
        DependencyContainer.register(AppConfigurationManaging.self) { AppConfigurationManager() }
    }
    
    var body: some Scene {
        WindowGroup {
            content
                .attachDebugMenu(options: DebugMenuOptions.allCases)
        }
    }
    
    private var content: some View {
        
        @Inject
        var appConfigurationManager: AppConfigurationManaging
        
        guard !appConfigurationManager.getValue(for: DebugCongigurationKeys.alwaysShowOnboarding) else {
            return AnyView(WelcomeView(viewModel: WelcomeViewModel()))
        }
        
        guard appConfigurationManager.getValue(for: Keys.onboardingCompleted) else {
            return AnyView(WelcomeView(viewModel: WelcomeViewModel()))
        }
        
        return AnyView(AppTabView())
    }
}
