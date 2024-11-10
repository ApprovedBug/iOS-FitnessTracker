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

public enum MealError: Error {
    case fetchError
}

public protocol MealsRepository: Sendable {
    @MainActor func saveMeal(_ meal: Meal) async
    @MainActor func meals() async -> AnyPublisher<[Meal], MealError>
}

@MainActor
public struct LocalMealsRepository: MealsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    public func meals() async -> AnyPublisher<[Meal], MealError> {
        
        do {
            let fetchDescriptor = FetchDescriptor<Meal>(sortBy: [SortDescriptor(\.name)])
            let meals = try contextProvider.sharedModelContainer.mainContext.fetch(fetchDescriptor)
            return Just(meals).setFailureType(to: MealError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    public func saveMeal(_ meal: Meal) {
        contextProvider.sharedModelContainer.mainContext.insert(meal)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
