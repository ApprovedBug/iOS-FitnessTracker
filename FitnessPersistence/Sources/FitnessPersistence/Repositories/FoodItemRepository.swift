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

public protocol FoodItemRepository: Sendable {
    
    @MainActor func recentFoodItems() async -> AnyPublisher<Set<FoodItem>, FoodItemError>
    @MainActor func saveFoodItem(_ foodItem: FoodItem) async
}

@MainActor
public final class LocalFoodItemRepository: FoodItemRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func recentFoodItems() async -> AnyPublisher<Set<FoodItem>, FoodItemError> {
        
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
    
    public func saveFoodItem(_ foodItem: FoodItem) async {
        contextProvider.sharedModelContainer.mainContext.insert(foodItem)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
