//
//  MeasurementUnit.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 02/11/2024.
//

import Foundation

public enum MeasurementUnit: String, Codable, CaseIterable {
    case millilitres = "ml"
    case grams = "g"
    case item = "serving"
}
