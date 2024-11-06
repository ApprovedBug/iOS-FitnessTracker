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
        let addItemTapped: (FoodItem) -> Void
    }
    
    let foodItem: FoodItem
    let eventHandler: EventHandler
    
    var name: String
    
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
    
    init(foodItem: FoodItem, eventHandler: EventHandler) {
        self.foodItem = foodItem
        self.eventHandler = eventHandler
        self.name = foodItem.name
        
        servingSize = String(foodItem.servingSize)
    }
    
    convenience init(meal: Meal, eventHandler: EventHandler) {
        
        let totalCalories = meal.foodItems.reduce(0) { $0 + $1.kcal }
        let totalCarbs = meal.foodItems.reduce(0) { $0 + $1.carbs }
        let totalProteins = meal.foodItems.reduce(0) { $0 + $1.protein }
        let totalFats = meal.foodItems.reduce(0) { $0 + $1.fats }
        
        let foodItem = FoodItem(
            name: meal.name,
            kcal: totalCalories,
            carbs: totalCarbs,
            protein: totalProteins,
            fats: totalFats,
            measurementUnit: .item,
            servingSize: 1)
        
        self.init(foodItem: foodItem, eventHandler: eventHandler)
    }
    
    func addItemTapped() {
        eventHandler.addItemTapped(foodItem)
    }
}

