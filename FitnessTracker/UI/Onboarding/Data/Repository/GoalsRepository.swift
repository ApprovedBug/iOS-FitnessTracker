//
//  GoalsRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import Combine
import DependencyManagement
import FitnessPersistence
import Foundation
import SwiftData

enum GoalsError: Error {
    case fetchError
}

protocol GoalsRepository {
    
    func goalsForUser(userId: String) -> AnyPublisher<Goals, GoalsError>
    func saveGoals(goals: Goals, for user: String)
}

struct LocalGoalsRepository: GoalsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    @MainActor func goalsForUser(userId: String) -> AnyPublisher<Goals, GoalsError> {
        do {
            let descriptor = FetchDescriptor<Goals>()
            guard let entry = try contextProvider.sharedModelContainer.mainContext.fetch(descriptor).first else {
                return Fail(error: .fetchError).eraseToAnyPublisher()
            }
            return Just(entry).setFailureType(to: GoalsError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    @MainActor func saveGoals(goals: Goals, for user: String) {
        contextProvider.sharedModelContainer.mainContext.insert(goals)
    }
}
