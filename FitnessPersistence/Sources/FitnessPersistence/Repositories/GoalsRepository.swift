//
//  GoalsRepository.swift
//  FitnessTracker
//
//  Created by Jack Moseley on 06/04/2024.
//

import Combine
import DependencyManagement
import Foundation
import SwiftData

public enum GoalsError: Error {
    case fetchError
}

public protocol GoalsRepository {
    
    func goalsForUser(userId: String) -> AnyPublisher<Goals, GoalsError>
    func saveGoals(goals: Goals, for user: String)
    func deleteGoals(for user: String)
}

public struct LocalGoalsRepository: @preconcurrency GoalsRepository {
    
    @Inject var contextProvider: ContextProviding
    
    public init() {}
    
    @MainActor public func goalsForUser(userId: String) -> AnyPublisher<Goals, GoalsError> {
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
    
    @MainActor public func saveGoals(goals: Goals, for user: String) {
        contextProvider.sharedModelContainer.mainContext.insert(goals)
        try? contextProvider.sharedModelContainer.mainContext.save()
    }
    
    @MainActor public func deleteGoals(for user: String) {
        try? contextProvider.sharedModelContainer.mainContext.delete(model: Goals.self)
    }
}
