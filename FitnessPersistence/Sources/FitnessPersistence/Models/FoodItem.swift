//
//  FoodItem.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import Foundation
import SwiftData

@Model
public class FoodItem {
    
    public let name: String
    public let kcal: Double
    public let carbs: Double
    public let protein: Double
    public let fats: Double
    
    init(name: String, kcal: Double, carbs: Double, protein: Double, fats: Double) {
        self.name = name
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}
