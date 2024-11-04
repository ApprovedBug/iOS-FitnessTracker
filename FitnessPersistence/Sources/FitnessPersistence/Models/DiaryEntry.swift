//
//  DiaryEntry.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import Foundation
import SwiftData

@Model
public class DiaryEntry {
    
    public var timestamp: Date
    public var foodItem: FoodItem
    public var mealType: MealType
    public var servings: Double

    public init(timestamp: Date, foodItem: FoodItem, mealType: MealType, servings: Double) {
        self.timestamp = timestamp
        self.foodItem = foodItem
        self.mealType = mealType
        self.servings = servings
    }
}

extension DiaryEntry {
    
    public var totalCalories: Int {
        Int(Double(foodItem.kcal) * servings)
    }
    
    public var totalCarbs: Double {
        Double(foodItem.carbs) * servings
    }
    
    public var totalProteins: Double {
        Double(foodItem.protein) * servings
    }
    
    public var totalFats: Double {
        Double(foodItem.fats) * servings
    }
}
