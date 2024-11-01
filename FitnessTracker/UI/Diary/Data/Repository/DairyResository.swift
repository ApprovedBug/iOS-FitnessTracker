//
//  DairyFetching.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 30/10/2023.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

enum DiaryError: Error {
    case fetchError
}

protocol DiaryRepository {
    
    func diaryEntries() -> AnyPublisher<[DiaryEntry], DiaryError>
    func addDiaryEntry(foodItem: FoodItem, meal: Meal, day: Date)
}

struct LocalDiaryRepository: @preconcurrency DiaryRepository {
    
    @Inject var contextProvider: ContextProviding
    
    @MainActor func diaryEntries() -> AnyPublisher<[DiaryEntry], DiaryError> {
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(sortBy: [SortDescriptor(\.timestamp)])
            let entries = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor)
            return Just(entries).setFailureType(to: DiaryError.self).eraseToAnyPublisher()
        } catch {
            print("Fetch failed")
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor func addDiaryEntry(foodItem: FoodItem, meal: Meal, day: Date) {
        let diaryEntry = DiaryEntry(timestamp: day, foodItem: foodItem, meal: meal)
        contextProvider.sharedModelContainer.mainContext.insert(diaryEntry)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
}
