//
//  MealItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 07/11/2024.
//

import FitnessPersistence
import Foundation

@Observable
class MealItemViewModel: Identifiable {
    
    struct EventHandler {
        let addMealTapped: @MainActor (Meal) async -> Void
        let deleteMealTapped: @MainActor (Meal) -> Void
    }
    
    let meal: Meal
    let eventHandler: EventHandler
    var isExpanded = false
    var isShowingEditMeal = false
    
    var kcal: String {
        String(format: "%.0f", meal.foodItems.reduce(0) { $0 + Double($1.foodItem.kcal) * $1.servings })
    }
    
    var name: String {
        meal.name
    }
    
    @ObservationIgnored
    lazy var carbs: String = {
        String(format: "%.1f", meal.foodItems.reduce(0) { $0 + ($1.foodItem.carbs * $1.servings) })
    }()
    
    @ObservationIgnored
    lazy var proteins: String = {
        String(format: "%.1f", meal.foodItems.reduce(0) { ($0 + $1.foodItem.protein * $1.servings) })
    }()
    
    @ObservationIgnored
    lazy var fats: String = {
        String(format: "%.1f", meal.foodItems.reduce(0) { ($0 + $1.foodItem.fats * $1.servings) })
    }()
    
    init(meal: Meal, eventHandler: EventHandler) {
        
        self.meal = meal
        self.eventHandler = eventHandler
    }
    
    @MainActor
    func addItemTapped() async {
        await eventHandler.addMealTapped(meal)
    }
    
    @MainActor
    func deleteMealTapped() {
        eventHandler.deleteMealTapped(meal)
    }
    
    @MainActor
    func editMealTapped() {
        isShowingEditMeal = true
    }
    
    func toggleExpanded() {
        isExpanded.toggle()
    }
}
