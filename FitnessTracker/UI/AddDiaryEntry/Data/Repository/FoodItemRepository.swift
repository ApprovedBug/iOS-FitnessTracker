//
//  FoodItemRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 12/09/2024.
//

import Combine
import SwiftData
import DependencyManagement
import FitnessPersistence
import Foundation

enum FoodItemError: Error {
    case fetchError
}

protocol FoodItemRepository {
    
    func foodItems(name: String) -> AnyPublisher<[FoodItem], FoodItemError>
    func saveFoodItem(_ foodItem: FoodItem)
}

struct LocalFoodItemRepository: @preconcurrency FoodItemRepository {
    
    @Inject var contextProvider: ContextProviding
    
    @MainActor func foodItems(name: String) -> AnyPublisher<[FoodItem], FoodItemError> {
        
        do {
            let namePredicate = #Predicate<FoodItem> { item in
                item.name.localizedStandardContains(name)
            }
            let descriptor = FetchDescriptor<FoodItem>(predicate: namePredicate, sortBy: [SortDescriptor(\.name)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: FoodItemError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor func saveFoodItem(_ foodItem: FoodItem) {
        contextProvider.sharedModelContainer.mainContext.insert(foodItem)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
