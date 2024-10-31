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
    
    let foodItem: FoodItem
    
    var name: String {
        foodItem.name
    }
    
    var kcal: String {
        String(foodItem.kcal)
    }
    
    var carbs: String {
        String(foodItem.carbs)
    }
    
    var protein: String {
        String(foodItem.protein)
    }
    
    var fat: String {
        String(foodItem.fats)
    }
    
    init(foodItem: FoodItem) {
        self.foodItem = foodItem
    }
}

