//
//  MealDetailsItemViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 16/11/2024.
//

import FitnessPersistence
import Foundation

@Observable
class MealDetailsItemViewModel: Identifiable {
    
    let foodItem: MealFoodItem
    
    var name: String {
        foodItem.foodItem.name
    }
    
    init(foodItem: MealFoodItem) {
        self.foodItem = foodItem
    }
}
