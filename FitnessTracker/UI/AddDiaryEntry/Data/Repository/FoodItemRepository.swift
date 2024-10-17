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
    
    func foodItems(for day: Date) -> AnyPublisher<[FoodItem], FoodItemError>
}

struct LocalFoodItemRepository: FoodItemRepository {
    
    @Inject var contextProvider: ContextProviding
    
    @MainActor func foodItems(for day: Date) -> AnyPublisher<[FoodItem], FoodItemError> {
        
        do {
            let descriptor = FetchDescriptor<FoodItem>(sortBy: [SortDescriptor(\.name)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: FoodItemError.self).eraseToAnyPublisher()
        } catch {
            print("Fetch failed")
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
}
