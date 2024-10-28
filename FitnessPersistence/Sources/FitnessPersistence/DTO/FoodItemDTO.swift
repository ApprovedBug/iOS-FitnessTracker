//
//  FoodItemDTO.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 27/10/2024.
//

import Foundation

public final class FoodItemDTO: Sendable {
    public let name: String
    public let calories: Int
    public let protein: Double
    public let carbs: Double
    public let fats: Double
    
    init(name: String, calories: Int, protein: Double, carbs: Double, fats: Double) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
    
    public convenience init(foodItem: FoodItem) {
        self.init(
            name: foodItem.name,
            calories: foodItem.kcal,
            protein: foodItem.protein,
            carbs: foodItem.carbs,
            fats: foodItem.fats
        )
    }
}
