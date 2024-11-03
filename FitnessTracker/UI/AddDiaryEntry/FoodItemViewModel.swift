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
    
    var name: String {
        foodItem.name
    }
    
    var kcal: String {
        String(foodItem.kcal)
    }
    
    var carbs: String {
        String(foodItem.carbs)
    }
    
    var proteins: String {
        String(foodItem.protein)
    }
    
    var fats: String {
        String(foodItem.fats)
    }
    
    var servingSize: String
    
    var measurementUnit: String {
        String(foodItem.measurementUnit.rawValue)
    }
    
    init(foodItem: FoodItem, eventHandler: EventHandler) {
        self.foodItem = foodItem
        self.eventHandler = eventHandler
        servingSize = String(foodItem.servingSize)
    }
    
    func addItemTapped() {
        eventHandler.addItemTapped(foodItem)
    }
}

