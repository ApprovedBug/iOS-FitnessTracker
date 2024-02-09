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
    
    var timestamp: Date
    var foodItem: FoodItem
    var meal: Meal

    init(timestamp: Date, foodItem: FoodItem, meal: Meal) {
        self.timestamp = timestamp
        self.foodItem = foodItem
        self.meal = meal
    }
}
