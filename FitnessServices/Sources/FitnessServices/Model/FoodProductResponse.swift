//
//  FoodProductResponse.swift
//  FitnessTrackerServices
//
//  Created by Jack Moseley on 10/11/2024.
//

import Foundation

// Top-level struct for both success and error responses
public struct FoodInfoDetailResponse: Sendable, Codable {
    let code: String
    let errors: [ErrorDetail]?
    let product: FoodProduct?
    let result: Result
    let status: String
    let warnings: [String]?
}

public struct FoodInfoSearchResponse: Sendable, Codable {
    let count: Int?
    let page: Int?
    let pageCount: Int?
    let pageSize: Int?
    let products: [FoodProduct]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case page
        case products
        case pageCount = "page_count"
        case pageSize = "page_size"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        count = try container.decodeToInt(forKey: .count)
        page = try container.decodeToInt(forKey: .page)
        pageCount = try container.decodeToInt(forKey: .pageCount)
        pageSize = try container.decodeToInt(forKey: .pageSize)
        products = try container.decodeIfPresent([FoodProduct].self, forKey: .products)
    }
}

// Product struct
public struct FoodProduct: Sendable, Codable {
    public let code: String
    public let nutriments: Nutrients
    public let productName: String
    public let brand: String?
    public let servingQuantity: Double?
    public let servingQuantityUnit: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case nutriments
        case productName = "product_name"
        case brand = "brands"
        case servingQuantity = "serving_quantity"
        case servingQuantityUnit = "serving_quantity_unit"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(String.self, forKey: .code)
        nutriments = try container.decode(Nutrients.self, forKey: .nutriments)
        productName = try container.decode(String.self, forKey: .productName)
        brand = try container.decodeIfPresent(String.self, forKey: .brand)
        servingQuantity = try container.decodeToDouble(forKey: .servingQuantity)
        servingQuantityUnit = try container.decodeIfPresent(String.self, forKey: .servingQuantityUnit)
    }
}

// Nutrients struct
public struct Nutrients: Sendable, Codable {
    public let carbohydrates: Double?
    public let carbohydrates100g: Double?
    public let carbohydratesServing: Double?
    public let carbohydratesUnit: String?
    public let carbohydratesValue: Double?
    
    public let energy: Double?
    public let energyKcal: Double?
    public let energyKcal100g: Double?
    public let energyKcalServing: Double?
    public let energyKcalUnit: String?
    public let energyKcalValue: Double?
    public let energyKcalValueComputed: Double?
    
    public let energy100g: Double?
    public let energyServing: Double?
    public let energyUnit: String?
    public let energyValue: Double?
    
    public let fat: Double?
    public let fat100g: Double?
    public let fatServing: Double?
    public let fatUnit: String?
    public let fatValue: Double?
    
    public let fiber: Double?
    public let fiber100g: Double?
    public let fiberServing: Double?
    public let fiberUnit: String?
    public let fiberValue: Double?
    
    public let nutritionScoreFr: Int?
    public let nutritionScoreFr100g: Int?
    
    public let proteins: Double?
    public let proteins100g: Double?
    public let proteinsServing: Double?
    public let proteinsUnit: String?
    public let proteinsValue: Double?
    
    public let salt: Double?
    public let salt100g: Double?
    public let saltServing: Double?
    public let saltUnit: String?
    public let saltValue: Double?
    
    public let saturatedFat: Double?
    public let saturatedFat100g: Double?
    public let saturatedFatServing: Double?
    public let saturatedFatUnit: String?
    public let saturatedFatValue: Double?
    
    public let sodium: Double?
    public let sodium100g: Double?
    public let sodiumServing: Double?
    public let sodiumUnit: String?
    public let sodiumValue: Double?
    
    public let sugars: Double?
    public let sugars100g: Double?
    public let sugarsServing: Double?
    public let sugarsUnit: String?
    public let sugarsValue: Double?
    
    // Custom CodingKeys to map JSON keys
    enum CodingKeys: String, CodingKey {
        case carbohydrates, energy, fat, fiber, nutritionScoreFr, proteins, salt, saturatedFat, sodium, sugars
        case carbohydrates100g = "carbohydrates_100g"
        case carbohydratesServing = "carbohydrates_serving"
        case carbohydratesUnit = "carbohydrates_unit"
        case carbohydratesValue = "carbohydrates_value"
        case energyKcal = "energy-kcal"
        case energyKcal100g = "energy-kcal_100g"
        case energyKcalServing = "energy-kcal_serving"
        case energyKcalUnit = "energy-kcal_unit"
        case energyKcalValue = "energy-kcal_value"
        case energyKcalValueComputed = "energy-kcal_value_computed"
        case energy100g = "energy_100g"
        case energyServing = "energy_serving"
        case energyUnit = "energy_unit"
        case energyValue = "energy_value"
        case fat100g = "fat_100g"
        case fatServing = "fat_serving"
        case fatUnit = "fat_unit"
        case fatValue = "fat_value"
        case fiber100g = "fiber_100g"
        case fiberServing = "fiber_serving"
        case fiberUnit = "fiber_unit"
        case fiberValue = "fiber_value"
        case nutritionScoreFr100g = "nutrition-score-fr_100g"
        case proteins100g = "proteins_100g"
        case proteinsServing = "proteins_serving"
        case proteinsUnit = "proteins_unit"
        case proteinsValue = "proteins_value"
        case salt100g = "salt_100g"
        case saltServing = "salt_serving"
        case saltUnit = "salt_unit"
        case saltValue = "salt_value"
        case saturatedFat100g = "saturated-fat_100g"
        case saturatedFatServing = "saturated-fat_serving"
        case saturatedFatUnit = "saturated-fat_unit"
        case saturatedFatValue = "saturated-fat_value"
        case sodium100g = "sodium_100g"
        case sodiumServing = "sodium_serving"
        case sodiumUnit = "sodium_unit"
        case sodiumValue = "sodium_value"
        case sugars100g = "sugars_100g"
        case sugarsServing = "sugars_serving"
        case sugarsUnit = "sugars_unit"
        case sugarsValue = "sugars_value"
    }
}

// Result struct
struct Result: Codable {
    let id: String
    let lcName: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case lcName = "lc_name"
        case name
    }
}

// ErrorDetail struct
struct ErrorDetail: Sendable, Codable {
    let field: ErrorField
    let impact: ErrorImpact
    let message: ErrorMessage
}

// ErrorField struct
struct ErrorField: Sendable, Codable {
    let id: String
    let value: String
}

// ErrorImpact struct
struct ErrorImpact: Sendable, Codable {
    let id: String
    let lcName: String
    let name: String
}

// ErrorMessage struct
struct ErrorMessage: Sendable, Codable {
    let id: String
    let lcName: String
    let name: String
}

