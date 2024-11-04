//
//  File.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 04/11/2024.
//

import Foundation
import SwiftData

@Model
public class Meal {
    
    public var name: String
    public var foodItems: [FoodItem]
    
    public init(name: String, foodItems: [FoodItem]) {
        self.name = name
        self.foodItems = foodItems
    }
}
