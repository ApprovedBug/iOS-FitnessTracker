//
//  FoodItemRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 12/09/2024.
//

import DependencyManagement
import Foundation
import SwiftData

public enum FoodItemError: Error {
    case fetchError
}

public protocol FoodItemRepository: Sendable {
    
    @MainActor func recentFoodItems() -> [FoodItem]
    @MainActor func saveFoodItem(_ foodItem: FoodItem) async
}

@MainActor
public final class LocalFoodItemRepository: FoodItemRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func recentFoodItems() -> [FoodItem] {
        
        do {
            var descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            descriptor.fetchLimit = 30
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return entries.map(\.foodItem).uniqued()
        } catch {
            return []
        }
    }
    
    public func saveFoodItem(_ foodItem: FoodItem) async {
        contextProvider.sharedModelContainer.mainContext.insert(foodItem)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
