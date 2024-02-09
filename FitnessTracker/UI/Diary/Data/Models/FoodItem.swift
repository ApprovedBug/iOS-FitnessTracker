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
    
    let name: String
    let kcal: Double
    let carbs: Double
    let protein: Double
    let fats: Double
    
    init(name: String, kcal: Double, carbs: Double, protein: Double, fats: Double) {
        self.name = name
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}
