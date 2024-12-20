//
//  FootItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 31/10/2024.
//

import FitnessPersistence
import SwiftUI

@Observable
class FoodItemViewModel: Identifiable {
    
    struct EventHandler {
        let addItemTapped: @MainActor (FoodItem) async -> Void
    }
    
    let foodItem: FoodItem
    let eventHandler: EventHandler
    let meal: Meal?
    
    var name: String
    
    var brand: String {
        foodItem.brand
    }
    
    var kcal: String {
        String(foodItem.kcal)
    }
    
    var carbs: String {
        String(format: "%.1f", foodItem.carbs)
    }
    
    var proteins: String {
        String(format: "%.1f", foodItem.protein)
    }
    
    var fats: String {
        String(format: "%.1f", foodItem.fats)
    }
    
    var servingSize: String
    
    var measurementUnit: String {
        String(foodItem.measurementUnit.rawValue)
    }
    
    init(foodItem: FoodItem, eventHandler: EventHandler, meal: Meal? = nil) {
        self.foodItem = foodItem
        self.eventHandler = eventHandler
        self.name = foodItem.name
        self.meal = meal
        
        servingSize = String(foodItem.servingSize)
    }
    
    convenience init(meal: Meal, eventHandler: EventHandler) {
        
        let totalCalories = meal.foodItems.reduce(0) { $0 + $1.foodItem.kcal }
        let totalCarbs = meal.foodItems.reduce(0) { $0 + $1.foodItem.carbs }
        let totalProtein = meal.foodItems.reduce(0) { $0 + $1.foodItem.protein }
        let totalFat = meal.foodItems.reduce(0) { $0 + $1.foodItem.fats }
        
        let foodItem = FoodItem(
            name: meal.name,
            brand: "homemade",
            kcal: totalCalories,
            carbs: totalCarbs,
            protein: totalProtein,
            fats: totalFat,
            measurementUnit: .item,
            servingSize: 1)
        
        self.init(foodItem: foodItem, eventHandler: eventHandler, meal: meal)
    }
    
    @MainActor
    func addItemTapped() async {
        await eventHandler.addItemTapped(foodItem)
    }
}

