//
//  DiaryEntryDTO.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 28/10/2024.
//

import Foundation

public final class DiaryEntryDTO: Sendable {
    
    public let timestamp: Date
    public let foodItem: FoodItemDTO
    public let meal: Meal

    init(timestamp: Date, foodItem: FoodItemDTO, meal: Meal) {
        self.timestamp = timestamp
        self.foodItem = foodItem
        self.meal = meal
    }
    
    public convenience init(diaryEntry: DiaryEntry) {
        let foodItem = FoodItemDTO(foodItem: diaryEntry.foodItem)
        
        self.init(timestamp: diaryEntry.timestamp, foodItem: foodItem, meal: diaryEntry.meal)
    }
}
