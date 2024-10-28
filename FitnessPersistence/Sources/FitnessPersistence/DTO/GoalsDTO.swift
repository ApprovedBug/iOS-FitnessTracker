//
//  GoalsDTO.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 28/10/2024.
//

import Foundation

public final class GoalsDTO: Sendable {
    
    public let kcal: Int
    public let carbs: Double
    public let protein: Double
    public let fats: Double
    
    public init(kcal: Int, carbs: Double, protein: Double, fats: Double) {
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
    
    public convenience init(goals: Goals) {
        self.init(kcal: goals.kcal, carbs: goals.carbs, protein: goals.protein, fats: goals.fats)
    }
}
