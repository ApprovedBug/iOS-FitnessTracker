//
//  FoodItemRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 12/09/2024.
//

import Combine
import SwiftData
import DependencyManagement
import Foundation

public enum FoodItemError: Error {
    case fetchError
}

public protocol FoodItemRepository {
    
    func foodItems(name: String) -> AnyPublisher<[FoodItem], FoodItemError>
    func recentFoodItems() -> AnyPublisher<Set<FoodItem>, FoodItemError>
    func saveFoodItem(_ foodItem: FoodItem)
}

public struct LocalFoodItemRepository: @preconcurrency FoodItemRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    @MainActor public func foodItems(name: String) -> AnyPublisher<[FoodItem], FoodItemError> {
        
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
    
    @MainActor public func recentFoodItems() -> AnyPublisher<Set<FoodItem>, FoodItemError> {
        
        do {
            var descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            descriptor.fetchLimit = 30
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            var items: Set<FoodItem> = []
            for entry in entries {
                items.insert(entry.foodItem)
            }
            return Just(items).setFailureType(to: FoodItemError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor public func saveFoodItem(_ foodItem: FoodItem) {
        contextProvider.sharedModelContainer.mainContext.insert(foodItem)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
