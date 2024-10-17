//
//  Goals.swift
//  
//
//  Created by Jack Moseley on 03/04/2024.
//

import Foundation
import SwiftData

@Model
public class Goals {
    
    public private(set) var kcal: Int
    public private(set) var carbs: Double
    public private(set) var protein: Double
    public private(set) var fats: Double
    
    public init(kcal: Int, carbs: Double, protein: Double, fats: Double) {
        self.kcal = kcal
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}
