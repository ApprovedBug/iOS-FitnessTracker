//
//  FoodItemRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 12/09/2024.
//

import SwiftData
import DependencyManagement
import FitnessPersistence
import Foundation

protocol FoodItemRepository {
    
    func foodItems(for day: Date) async throws -> [FoodItemDTO]
}

@ModelActor
actor LocalFoodItemRepository: FoodItemRepository, Sendable {
    
    @Inject var contextProviding: ContextProviding
    
    private var context: ModelContext { modelExecutor.modelContext }
    
    func foodItems(for day: Date) async throws -> [FoodItemDTO] {
        
        let descriptor = FetchDescriptor<FoodItem>(sortBy: [SortDescriptor(\.name)])
        let items = try context.fetch(descriptor)
        let itemDtos = items.map { FoodItemDTO(foodItem: $0) }
        
        return itemDtos
    }
}
