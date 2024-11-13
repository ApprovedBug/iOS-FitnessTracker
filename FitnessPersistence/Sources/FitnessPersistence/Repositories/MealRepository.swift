//
//  MealRepository.swift
//  FitnessPersistence
//
//  Created by Jack Moseley on 05/11/2024.
//

import Combine
import DependencyManagement
import Foundation
import SwiftData

public protocol MealsRepository: Sendable {
    @MainActor func saveMeal(_ meal: Meal)
    @MainActor func meals() -> [Meal]
    @MainActor func deleteMeal(_ meal: Meal)
}

@MainActor
public struct LocalMealsRepository: MealsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func meals() -> [Meal] {
        
        do {
            let fetchDescriptor = FetchDescriptor<Meal>(sortBy: [SortDescriptor(\.name)])
            let meals = try contextProvider.sharedModelContainer.mainContext.fetch(fetchDescriptor)
            return meals
        } catch {
            return []
        }
    }
    
    public func saveMeal(_ meal: Meal) {
        contextProvider.sharedModelContainer.mainContext.insert(meal)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    public func deleteMeal(_ meal: Meal) {
        contextProvider.sharedModelContainer.mainContext.delete(meal)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
