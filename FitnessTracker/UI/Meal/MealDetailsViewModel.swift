//
//  MealDetailsViewModel.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 16/11/2024.
//

import FitnessPersistence
import Foundation

@Observable
class MealDetailsViewModel {
    private let meal: Meal
    
    var title: String {
        meal.name
    }
    
    var foodItems: [MealDetailsItemViewModel]
    
    init(meal: Meal) {
        self.meal = meal
        foodItems = meal.foodItems.map(MealDetailsItemViewModel.init)
    }
}
