//
//  DebugMenuOptions.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 03/11/2024.
//

import Foundation
import ConfigurationManagement
import DependencyManagement
import DebugTools
import FitnessPersistence

enum DebugMenuOptions: String, DebugMenuOption, CaseIterable {
    
    case alwaysShowOnboarding = "Always Show Onboarding"
    case resetOnboardingStatus = "Reset Onboarding Status"
    case resetGoals = "Reset Goals"
    case purgeAllData = "Purge All Data"
    case populateTestData = "Populate Test Data"
    
    var appConfigurationKey: AppConfigurationKey? {
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
                .button { resetOnboardingStatus() }
            case .resetGoals:
                .button { Task { await resetGoals() } }
            case .purgeAllData:
                .button { purgeAllData() }
            case .populateTestData:
                .button { Task { await populateTestData() } }
        }
    }
    
    func resetOnboardingStatus() {
        let appConfigurationManager = DependencyContainer.resolve(AppConfigurationManaging.self)
        appConfigurationManager?.setValue(value: false, key: Keys.onboardingCompleted)
    }
    
    func resetGoals() async {
        let goalsRepository = DependencyContainer.resolve(GoalsRepository.self)
        await goalsRepository?.deleteGoals(for: "current")
    }
    
    func purgeAllData() {
        resetOnboardingStatus()
        
        let contextProvider = DependencyContainer.resolve(ContextProviding.self)
        try? contextProvider?.sharedModelContainer.erase()
    }
    
    @MainActor
    func populateTestData() async {
        
        let appConfigurationManager = DependencyContainer.resolve(AppConfigurationManaging.self)
        appConfigurationManager?.setValue(value: true, key: Keys.onboardingCompleted)
        
        // test goals
        
        let goalsRepository = DependencyContainer.resolve(GoalsRepository.self)
        
        let goals = Goals(
            kcal: 1653,
            carbs: 186,
            protein: 83,
            fats: 64
        )
        
        await goalsRepository?.saveGoals(goals: goals, for: "current")
        
        // test food items
        
        let foodItemRepository = DependencyContainer.resolve(FoodItemRepository.self)
        
        let foodItem1 = FoodItem(
            name: "Fat Free Greek Yoghurt",
            kcal: 66,
            carbs: 6,
            protein: 9.8,
            fats: 0.3,
            measurementUnit: .grams,
            servingSize: 100
        )
        
        let foodItem2 = FoodItem(
            name: "Quaker Oats Golden Crunch",
            kcal: 214,
            carbs: 32.2,
            protein: 4.3,
            fats: 5.1,
            measurementUnit: .grams,
            servingSize: 50
        )
        
        let foodItem3 = FoodItem(
            name: "Lindt Dark Chocolate (70%)",
            kcal: 11,
            carbs: 6.8,
            protein: 1.9,
            fats: 8.2,
            measurementUnit: .grams,
            servingSize: 20
        )
        
        let foodItem4 = FoodItem(
            name: "Morrisons Orange Juice (smooth)",
            kcal: 41,
            carbs: 9,
            protein: 0.7,
            fats: 0.1,
            measurementUnit: .millilitres,
            servingSize: 100
        )
        
        let foodItem5 = FoodItem(
            name: "Nduja and Ventricina Salami Pizza",
            kcal: 545,
            carbs: 63.6,
            protein: 20.9,
            fats: 19.7,
            measurementUnit: .item,
            servingSize: 1
        )
        
        await foodItemRepository?.saveFoodItem(foodItem1)
        await foodItemRepository?.saveFoodItem(foodItem2)
        await foodItemRepository?.saveFoodItem(foodItem3)
        await foodItemRepository?.saveFoodItem(foodItem4)
        await foodItemRepository?.saveFoodItem(foodItem5)
        
        // test diary entries items
        
        let diaryRepository = DependencyContainer.resolve(DiaryRepository.self)
        
        let diaryEntry1 = DiaryEntry(
            timestamp: Date.now,
            foodItem: foodItem1,
            mealType: .breakfast,
            servings: 1
        )
        
        let diaryEntry2 = DiaryEntry(
            timestamp: Date.now,
            foodItem: foodItem2,
            mealType: .breakfast,
            servings: 1
        )
        
        let diaryEntry3 = DiaryEntry(
            timestamp: Date.now,
            foodItem: foodItem4,
            mealType: .breakfast,
            servings: 2.5
        )
        
        let diaryEntry4 = DiaryEntry(
            timestamp: Date.now,
            foodItem: foodItem5,
            mealType: .dinner,
            servings: 0.5
        )
        
        diaryRepository?.add(diaryEntry: diaryEntry1)
        diaryRepository?.add(diaryEntry: diaryEntry2)
        diaryRepository?.add(diaryEntry: diaryEntry3)
        diaryRepository?.add(diaryEntry: diaryEntry4)
    }
}
