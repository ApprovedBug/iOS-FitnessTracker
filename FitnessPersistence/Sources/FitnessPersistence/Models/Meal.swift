//
//  Meal.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 04/11/2024.
//

import Foundation
import SwiftData

@Model
public class Meal {
    
    public var name: String
    public var foodItems: [MealFoodItem]
    
    public init(name: String, foodItems: [MealFoodItem]) {
        self.name = name
        self.foodItems = foodItems
    }
}

@Model
public class MealFoodItem {
    
    public var servings: Double
    public var foodItem: FoodItem
    
    public init(servings: Double, foodItem: FoodItem) {
        self.servings = servings
        self.foodItem = foodItem
    }
}
