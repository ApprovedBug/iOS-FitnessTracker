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

public protocol MealsRepository {
    func saveMeal(_ meal: Meal)
    func meals() -> AnyPublisher<[Meal], MealError>
}

public struct LocalMealsRepository: @preconcurrency MealsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    @MainActor public func meals() -> AnyPublisher<[Meal], MealError> {
        
        do {
            let fetchDescriptor = FetchDescriptor<Meal>()
            let meals = try contextProvider.sharedModelContainer.mainContext.fetch(fetchDescriptor)
            return Just(meals).setFailureType(to: MealError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor public func saveMeal(_ meal: Meal) {
        contextProvider.sharedModelContainer.mainContext.insert(meal)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
