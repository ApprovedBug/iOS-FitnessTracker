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
    public var meal: Meal
    public var servings: Double

    public init(timestamp: Date, foodItem: FoodItem, meal: Meal, servings: Double) {
        self.timestamp = timestamp
        self.foodItem = foodItem
        self.meal = meal
        self.servings = servings
    }
}
