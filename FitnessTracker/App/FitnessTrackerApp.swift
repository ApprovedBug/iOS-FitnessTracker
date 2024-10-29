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
        // Register your dependencies here
        DependencyContainer.register(ContextProviding.self) {
            PersistenceManager()
        }
        
        DependencyContainer.register(UserDefaultsProtocol.self) {
            UserDefaults.standard
        }
        
        DependencyContainer.register(GoalsRepository.self) {
            LocalGoalsRepository()
        }
        
        DependencyContainer.register(DiaryRepository.self) {
            LocalDiaryRepository()
        }
        
        DependencyContainer.register(FoodItemRepository.self) {
            LocalFoodItemRepository()
        }
        
        DependencyContainer.register(AppConfigurationManaging.self) {
            AppConfigurationManager()
        }
    }
    
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            content()
                .animation(.default, value: viewModel.root)
                .attachDebugMenu(options: DebugMenuOptions.allCases)
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        
        switch viewModel.root {
            case .splash:
                SplashView()
            case .welcome:
                WelcomeView(viewModel: WelcomeViewModel(), appRootManaging: viewModel)
            case .dashboard:
                AppTabView()
        }
    }
}
