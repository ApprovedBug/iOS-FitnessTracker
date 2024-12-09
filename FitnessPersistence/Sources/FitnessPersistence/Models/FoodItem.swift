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
    public private(set) var brand: String
    public private(set) var kcal: Int
    public private(set) var carbs: Double
    public private(set) var protein: Double
    public private(set) var fats: Double
    public private(set) var measurementUnit: MeasurementUnit
    public private(set) var servingSize: Int
    
    public init(
        name: String,
        brand: String,
        kcal: Int,
        carbs: Double,
        protein: Double,
        fats: Double,
        measurementUnit: MeasurementUnit,
        servingSize: Int
    ) {
        self.name = name
        self.brand = brand
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
        self.measurementUnit = measurementUnit
        self.servingSize = servingSize
    }
}
