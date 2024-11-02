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
        
        let persistenceManager = PersistenceManager()
        DependencyContainer.register(ContextProviding.self) {
            persistenceManager
        }
        
        DependencyContainer.register(UserDefaultsProtocol.self) {
            UserDefaults.standard
        }
        
        let goalsRepository = LocalGoalsRepository()
        DependencyContainer.register(GoalsRepository.self) {
            goalsRepository
        }
        
        let diaryRepository = LocalDiaryRepository()
        DependencyContainer.register(DiaryRepository.self) {
            diaryRepository
        }
        
        let foodItemsRepository = LocalFoodItemRepository()
        DependencyContainer.register(FoodItemRepository.self) {
            foodItemsRepository
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
