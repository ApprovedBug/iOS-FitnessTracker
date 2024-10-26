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
    
    public private(set) var name: String
    public private(set) var kcal: Int
    public private(set) var carbs: Double
    public private(set) var protein: Double
    public private(set) var fats: Double
    
    public init(name: String, kcal: Int, carbs: Double, protein: Double, fats: Double) {
        self.name = name
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}
