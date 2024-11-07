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
        let addMealTapped: (Meal) -> Void
    }
    
    let meal: Meal
    let eventHandler: EventHandler
    
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
    
    func addItemTapped() {
        eventHandler.addMealTapped(meal)
    }
}
