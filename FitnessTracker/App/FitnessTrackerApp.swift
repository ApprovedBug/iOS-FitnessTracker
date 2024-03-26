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
    
    enum Keys: String, AppConfigurationKey, DebugMenuOption, CaseIterable {
        
        case alwaysShowOnboarding
        
        var name: String {
            return rawValue
        }
        
        var title: String {
            return rawValue.localizedLowercase
        }
    }
    
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
        
        DependencyContainer.register(DiaryFetching.self) {
            MockDiaryRepository()
        }
        
        DependencyContainer.register(AppConfigurationManaging.self) {
            AppConfigurationManager()
        }
    }

    var body: some Scene {
        
        WindowGroup {
            content
                .attachDebugMenu(options: Keys.allCases)
        }
    }
    
    private var content: some View {
        
        @Inject
        var appConfigurationManager: AppConfigurationManaging
        
        if !appConfigurationManager.getValue(for: Keys.alwaysShowOnboarding) {
            return AnyView(WelcomeView(viewModel: WelcomeViewModel()))
        } else {
            return AnyView(AppTabView())
        }
    }
}
