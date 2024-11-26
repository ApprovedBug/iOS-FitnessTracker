//
//  WeightEntry.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 24/11/2024.
//

import Foundation
import SwiftData

@Model
public class WeightEntry {
    
    public var date: Date
    public var weight: Double
    
    public init(date: Date, weight: Double) {
        self.date = date
        self.weight = weight
    }
}
